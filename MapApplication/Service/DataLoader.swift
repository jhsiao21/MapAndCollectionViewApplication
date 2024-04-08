//
//  DataLoader.swift
//  LionTravel
//
//  Created by Henry Hung on 2024/4/3.
//

import Foundation

class DataLoader {
    
    static let shared = DataLoader()
    
    private init() {}
    
    func loadLocalJSONData(from fileURL: URL, completion: @escaping (Result<Location, Error>) -> Void) {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let root = try decoder.decode(Location.self, from: data)
            completion(.success(root))
        } catch {
            print("Error loading or decoding local JSON file:", error.localizedDescription)
            completion(.failure(error))
        }
    }
}

struct Constant {
    static let localJSONURL = Bundle.main.url(forResource: "mockData", withExtension: "json")!
}
