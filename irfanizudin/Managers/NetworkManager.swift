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
        var urlRequest = URLRequest(url: url)
        
        // use the request timeout interval to simulate failed fetch request with poor internet connection
        urlRequest.timeoutInterval = 3
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                guard let error = error else { return }
                completion(.failure(error))
                return
            }
            
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
