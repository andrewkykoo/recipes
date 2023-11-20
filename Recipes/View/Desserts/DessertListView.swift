//
//  MealListView.swift
//  Recipes
//
//  Created by Andrew Koo on 11/16/23.
//

import SwiftUI

struct DessertListView: View {
    @StateObject var viewModel = DessertListViewModel()
    
    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading desserts...")
            } else if viewModel.meals.isEmpty {
                Text("No desserts available")
                    .padding()
            } else {
                List(viewModel.meals) { meal in
                    NavigationLink {
                        MealDetailView(meal: meal)
                    } label: {
                        HStack(spacing: 15) {
                            MealImageView(urlString: meal.strMealThumb)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                            Text(meal.strMeal)
                        }
                    }
                }
                .navigationTitle("Desserts")
                .listStyle(.plain)
                .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Something went wrong. Please check your network connection and try again"), dismissButton: .default(Text("Retry")))
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            viewModel.refreshMeals(category: "Dessert")
                        }, label: {
                            Image(systemName: "arrow.clockwise")
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    DessertListView()
}
