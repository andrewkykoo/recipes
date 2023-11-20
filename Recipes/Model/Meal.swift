//
//  Meal.swift
//  Recipes
//
//  Created by Andrew Koo on 11/16/23.
//

import Foundation

struct MealListResponse: Codable {
    let meals: [Meal]
}

struct Meal: Identifiable, Codable {
    var id: String { idMeal }
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}
