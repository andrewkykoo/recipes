//
//  MealImageView.swift
//  Recipes
//
//  Created by Andrew Koo on 11/16/23.
//

import SwiftUI

struct MealImageView: View {
    let urlString: String
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var hasError = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            } else if hasError {
                Text("Unable to load image")
            } else if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .onAppear {
            isLoading = true
            ImageLoader.loadImage(from: urlString) { fetchedImage in
                if let fetchedImage = fetchedImage {
                    self.image = fetchedImage
                } else {
                    hasError = true
                }
                isLoading = false
            }
        }
    }
}

#Preview {
    MealImageView(urlString: "https://www.themealdb.com/images/media/meals/adxcbq1619787919.jpg")
        .frame(width: 100, height: 100)
        .padding()
        .previewLayout(.sizeThatFits)
}
