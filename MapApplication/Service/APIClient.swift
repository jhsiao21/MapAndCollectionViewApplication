//
//  APIClient.swift
//  MapApplication
//
//  Created by LoganMacMini on 2024/4/7.
//

import Foundation
import UIKit

final class APIClient {
    static let shared = APIClient()
    
    private init() {}
    
    func fetchData(completion: @escaping (Location?, Error?) -> Void) {
                        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  //模擬API延遲
            DataLoader.shared.loadLocalJSONData(from: Constant.localJSONURL, completion: { result in
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, NSError(domain: "", code: 0))
                    print("Failed to fetch upcoming movies: \(error.localizedDescription)")
                }
            })
        }
    }
}
