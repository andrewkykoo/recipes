//
//  MealDetailViewModel.swift
//  Recipes
//
//  Created by Andrew Koo on 11/17/23.
//

import Foundation
import Combine

class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func getIndividualMeal(mealID: String) {
        isLoading = true
        let mealDetailURLString = "https://themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        guard let url = URL(string: mealDetailURLString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
                self.isLoading = false
            }
            return
        }
        
        NetworkUtility.downloadDataCombine(fromURL: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Failed to load meal details: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (mealDetailResponse: MealDetailResponse) in
                if let mealDetail = mealDetailResponse.meals.first {
                    self?.mealDetail = mealDetail
                } else {
                    self?.errorMessage = "Failed to load meal details"
                }
            })
            .store(in: &cancellables)
    }
}
