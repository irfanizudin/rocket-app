//
//  NetworkManager.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let baseURL = "https://api.spacexdata.com/v4"
    
    func getData<T: Codable>(endpoint: String, type: T.Type, completion: @escaping(Result<T, Error>) -> ()) {
        guard let url = URL(string: "\(baseURL+endpoint)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
        
}
