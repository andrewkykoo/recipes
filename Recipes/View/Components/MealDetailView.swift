//
//  MealDetailView.swift
//  Recipes
//
//  Created by Andrew Koo on 11/17/23.
//

import SwiftUI

struct MealDetailView: View {
    let meal: Meal
    @StateObject private var viewModel = MealDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Loading recipe details...").padding(.top, 5)
                    }
                } else if let mealDetail = viewModel.mealDetail {
                    VStack(alignment: .leading, spacing: 10) {
                        MealImageView(urlString: mealDetail.strMealThumb)
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .clipped()
                        
                        Text("Instructions")
                            .font(.headline)
                        
                        ForEach(mealDetail.instructionSteps, id: \.self) { step in
                            Text(step)
                                .padding(.bottom, 2)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ingredients")
                                .font(.headline)
                            ForEach(mealDetail.ingredientsWithMeasurements, id: \.id) { item in
                                Text("• \(item.ingredient): \(item.measurement)")
                                    .padding(.bottom, 2)
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("Unable to load meal details")
                }
            }
        }
        .navigationTitle(meal.strMeal)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.getIndividualMeal(mealID: meal.idMeal)
        }
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Something went wrong. Please try again"), dismissButton: .default(Text("Retry")))
        }
    }
}

#Preview {
    MealDetailView(meal: Meal(strMeal: "Apam balik", strMealThumb: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg", idMeal: "53049"))
}
