//
//  DessertListViewModel.swift
//  Recipes
//
//  Created by Andrew Koo on 11/16/23.
//

import Foundation

class DessertListViewModel: BaseMealListViewModel {
    
    override init() {
        super.init()
        getMeals(category: "Dessert")
    }
}
