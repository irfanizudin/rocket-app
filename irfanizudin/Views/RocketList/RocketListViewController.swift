//
//  RocketListViewController.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import UIKit
import Combine

class RocketListViewController: UIViewController {

    let vm = RocketViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    lazy var searchBar: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Seach rocket here..."
        search.searchBar.searchBarStyle = .minimal
        search.searchBar.tintColor = .label
        search.searchBar.autocorrectionType = .no
        search.searchBar.autocapitalizationType = .none
        return search
    }()
    
    lazy var rocketTableView: UITableView = {
        let table = UITableView()
        table.register(RocketTableViewCell.self, forCellReuseIdentifier: RocketTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "Rocket List"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchBar

        searchBar.searchResultsUpdater = self

        vm.getAllRockets()
        setupTableView()
        bindingVM()
    }
    
    private func setupTableView() {
        view.addSubview(rocketTableView)
        rocketTableView.delegate = self
        rocketTableView.dataSource = self
        rocketTableView.frame = view.bounds
    }
    

    private func bindingVM() {
        vm.$rockets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.rocketTableView.reloadData()
            }
        }
        .store(in: &cancellables)
    }

}

extension RocketListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.rockets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RocketTableViewCell.identifier, for: indexPath) as? RocketTableViewCell else {
            return UITableViewCell()
        }
        cell.accessoryType = .disclosureIndicator
        let rocket = vm.rockets[indexPath.row]
        cell.configureRocketImage(url: rocket.flickr_images?.randomElement() ?? "")
        cell.rocketName.text = rocket.name
        cell.rocketDescription.text = rocket.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = RocketDetailViewController()
        guard let rocketId = vm.rockets[indexPath.row].id else { return }
        vc.rocketId = rocketId
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RocketListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
