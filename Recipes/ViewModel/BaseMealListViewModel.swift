//
//  BaseMealListViewModel.swift
//  Recipes
//
//  Created by Andrew Koo on 11/18/23.
//

import Foundation

class BaseMealListViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func getMeals(category: String) {
        isLoading = true
        let encodedCategory = category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=\(encodedCategory)") else {
            errorMessage = "Invalid URL. Pleae provide a valid URL"
            return
        }
        
        NetworkUtility.downloadData(fromURL: url) { [weak self] (mealResponse: MealListResponse?) in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let mealResponse = mealResponse {
                    self?.meals = mealResponse.meals.sorted { $0.strMeal < $1.strMeal }
                    self?.errorMessage = nil
                } else {
                    self?.errorMessage = "Failed to load desserts. Please try again later"
                }
            }
        }
    }
    

    func refreshMeals(category: String) {
        getMeals(category: category)
    }
}
