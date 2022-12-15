//
//  FoodNavStackTwoView.swift
//  WWDC2022
//
//  Created by wenpu.duan on 2022/12/9.
//

import SwiftUI
// MARK: NavigationStack with Value-based Navigation Links

struct FoodsListTwoView: View {
    fileprivate var foodItems = partyFoods
    @State private var selectedFoodItems: [FoodItem] = []

    var body: some View {
        NavigationStack(path: $selectedFoodItems) {
            List(foodItems) { item in
                NavigationLink(value: item) {
                    FoodRow(food: item)
                }
            }
            .navigationTitle("Party Food")
            .navigationDestination(for: FoodItem.self) { item in
                FoodDetailTwoView(item: item, path: $selectedFoodItems)
            }
        }
    }
}

struct FoodDetailTwoView: View {
    let item: FoodItem
    @Binding var path: [FoodItem]

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(item.emoji)
                        .font(.system(size: 30))
                    Text(item.name)
                        .font(.title3)
                }
                .padding(.bottom, 4)
                Text(item.description)
                    .font(.caption)
                Divider()
                RelatedFoodsTwoView(relatedFoods: relatedFoods.random(3, except: item))
                if path.count > 1 {
                    Button("Back to First Item") { path.removeSubrange(1...) }
                }
            }
        }
    }
}

struct RelatedFoodsTwoView: View {
    @State var relatedFoods: [FoodItem]

    var body: some View {
        VStack {
            Text("Related Foods")
                .background(.background, in: RoundedRectangle(cornerRadius: 2))
            HStack {
                ForEach(relatedFoods) { food in
                    NavigationLink(value: food) {
                        Text(food.emoji)
                    }
                }
            }
        }
    }
}
