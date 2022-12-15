//
//  FoodNavStackView.swift
//  WWDC2022
//
//  Created by wenpu.duan on 2022/12/9.
//

// MARK: NavigationStack with View-based NavigationLinks
import SwiftUI

struct FoodsListView: View {
    fileprivate var foodItems = partyFoods
    @State private var selectedFoodItems: [FoodItem] = []

    var body: some View {
        NavigationStack {
            List(foodItems) { item in
                NavigationLink {
                    FoodDetailView(item: item)
                } label: {
                    FoodRow(food: item)
                }
            }
            .navigationTitle("Party Food")

        }
    }
}

struct FoodRow: View {
    let food: FoodItem

    var body: some View {
        HStack {
            Text(food.emoji)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
            Text(food.name)
                .font(.caption)
                .bold()
            Spacer()
            Text("\(food.quantity)")
        }
    }
}

struct FoodDetailView: View {
    let item: FoodItem

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
                RelatedFoodsView(relatedFoods: relatedFoods.random(3, except: item))
            }
        }
    }
}

struct RelatedFoodsView: View {
    @State var relatedFoods: [FoodItem]

    var body: some View {
        VStack {
            Text("Related Foods")
                .background(.background, in: RoundedRectangle(cornerRadius: 2))
            HStack {
                ForEach(relatedFoods) { food in
                    NavigationLink {
                        FoodDetailView(item: food)
                    } label: { Text(food.emoji) }
                }
            }
        }
    }
}
