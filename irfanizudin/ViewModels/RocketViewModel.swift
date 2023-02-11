//
//  RocketListViewModel.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import Foundation

class RocketViewModel: ObservableObject {
    
    @Published var rockets: [Rocket] = []
    @Published var rocket: Rocket?
    
    func getAllRockets() {
        NetworkManager.shared.getData(endpoint: "/rockets", type: [Rocket].self) { [weak self] result in
            switch result {
            case .success(let rockets):
                DispatchQueue.main.async {
                    self?.rockets = rockets
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getRocketDetail(id: String) {
        NetworkManager.shared.getData(endpoint: "/rockets/\(id)", type: Rocket.self) { [weak self] result in
            switch result {
            case .success(let rocket):
                DispatchQueue.main.async {
                    self?.rocket = rocket
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
