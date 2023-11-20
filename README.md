# Recipes

### Introduction
Recipes provides users with a variety of meal recipes from different categories, leveraging TheMealDB API.

Botn URLSession of Foundation framework and Combine framework are utilized for making network requests.

While the current version primarily showcases Desserts, the underlying architecture, built on the principles of inheritance, sets the stage for seamless expansion to include other categories in future updates.

```
class BaseListViewModel: ObservableObject {
    @Published var meals: [Meal] = []
    @Published var errorMessage: String?
    @Published var isLoading = false

    func getMeals(category: String) {...}

}

class DessertListViewModel: BaseMealListViewModel {
    
    override init() {
        super.init()
        getMeals(category: "Dessert")
    }
}

// Future addition
class PastaListViewModel: BaseMealListViewModel {
    
    override init() {
        super.init()
        getMeals(category: "Pasta")
    }
}

```




### Technology
* SwiftUI
* Combine
* UIKit
* TheMealDB API
