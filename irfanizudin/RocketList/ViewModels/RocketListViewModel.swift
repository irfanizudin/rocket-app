//
//  RocketListViewModel.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import Foundation

class RocketListViewModel: ObservableObject {
    
    @Published var rockets: [Rocket] = []
    
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
}
