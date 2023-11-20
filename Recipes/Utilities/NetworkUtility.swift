//
//  NetworkUtility.swift
//  Recipes
//
//  Created by Andrew Koo on 11/16/23.
//

import Foundation
import Combine

struct NetworkUtility {
    static func handleResponseStatusCode(response: HTTPURLResponse) {
        let statusCode = response.statusCode
        switch statusCode {
        case 100...199:
            print("Informational response: \(statusCode)")
            
        case 200...299:
            print("Success: \(statusCode)")
            
        case 300...399:
            print("Redirection: \(statusCode)")
            
        case 400...499:
            print("Client error: \(statusCode)")
            
        case 500...599:
            print("Server error: \(statusCode)")
            
        default:
            print("Unknown status code: \(statusCode)")
        }
    }
    
    static func downloadData<T: Codable>(fromURL url: URL, completionHandler: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data found")
                completionHandler(nil)
                return
            }
            
            guard error == nil else {
                print("Error: \(String(describing: error))")
                completionHandler(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                NetworkUtility.handleResponseStatusCode(response: httpResponse)
            } else {
                print("Invalid response")
                completionHandler(nil)
                return
            }
                        
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                print("Failed to decode JSON")
                completionHandler(nil)
                return
            }
            
            completionHandler(decodedResponse)
        }
        .resume()
    }
    
    static func downloadDataCombine<T: Codable>(fromURL url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                handleResponseStatusCode(response: httpResponse)
                
                guard 200...299 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
