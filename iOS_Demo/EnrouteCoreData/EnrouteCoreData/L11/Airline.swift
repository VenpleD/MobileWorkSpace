//
//  Airline.swift
//  EnrouteCoreData
//
//  Created by Venple on 2022/12/4.
//

import CoreData
import Combine

extension Airline: Comparable {
    static func withCode(_ code: String, in context: NSManagedObjectContext) -> Airline {
        let request = fetchRequest(predicate: NSPredicate(format: "code_ = %@", code))
        let results = (try? context.fetch(request)) ?? []
        if let airline = results.first {
            return airline
        } else {
            let airline = Airline(context: context)
            airline.code = code
            AirlineInfoRequest.fetch(code) { info in
                let airline = self.withCode(code, in: context)
                airline.name = info.name
                airline.shortName = info.shortname
                airline.objectWillChange.send()
                airline.flights.forEach { $0.objectWillChange.send() }
                try? context.save()
            }
            return airline
        }
    }
    
    var code: String {
        get { code_! }
        set { code_ = newValue }
    }
    var name: String {
        get { name_ ?? code}
        set { name_ = newValue}
    }
    var shortName: String {
        get { (shortName_ ?? "").isEmpty ? name : shortName_! }
        set { shortName_ = newValue}
    }
    var flights: Set<Flight> {
        get { (flights_ as? Set<Flight>) ?? [] }
        set { flights_ = newValue as NSSet }
    }
    var friendlyName: String { shortName.isEmpty ? name : shortName }
    
    public var id: String { code }
    
    public static func < (lhs: Airline, rhs: Airline) -> Bool {
        lhs.name < rhs.name
    }
}

extension Airline {
    public static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<Airline> {
        let reqeust = NSFetchRequest<Airline>(entityName: "Airline")
        reqeust.predicate = predicate
        reqeust.sortDescriptors = [NSSortDescriptor(key: "name_", ascending: true)]
        return reqeust
    }
}
