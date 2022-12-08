//
//  MapView.swift
//  EnrouteCoreData
//
//  Created by wenpu.duan on 2022/12/8.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {

    var annotations: [MKAnnotation]
    
    @Binding var selection: MKAnnotation?
    
    typealias UIViewType = MKMapView
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: context.coordinator.annotationViewIdentifier)
        mapView.addAnnotations(annotations)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if selection != nil {
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: selection!.coordinate, span: town), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(selection: $selection)
        return coordinator;
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        @Binding var selection: MKAnnotation?
        
        init(selection: Binding<MKAnnotation?>) {
            self._selection = selection
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView: MKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewIdentifier, for: annotation)
            annotationView.canShowCallout = true
            return  annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            selection = annotation
        }
        
        var annotationViewIdentifier: String = "MapView.AnnotationView"
    }
}
