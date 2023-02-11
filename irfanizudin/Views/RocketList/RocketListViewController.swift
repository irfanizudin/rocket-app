//
//  RocketListViewController.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import UIKit
import Combine
import SnapKit

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
        table.isHidden = true
        return table
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .medium)
        loading.startAnimating()
        return loading
    }()
    
    lazy var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading..."
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 15
        button.isHidden = true
        return button
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
        setupLoadingIndicator()
        
        bindingVM()
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        view.addSubview(loadingLabel)
        view.addSubview(retryButton)
        
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
         
        loadingLabel.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.bottom.equalTo(loadingLabel.snp.top).offset(-10)
            make.centerX.equalTo(loadingLabel.snp.centerX)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(loadingLabel.snp.bottom).offset(20)
            make.centerX.equalTo(loadingLabel.snp.centerX)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    
    @objc func didTapRetry() {
        vm.getAllRockets()
        vm.isRequestTimeout = false
        print("retry bro")
    }
    
    private func setupTableView() {
        view.addSubview(rocketTableView)
        rocketTableView.delegate = self
        rocketTableView.dataSource = self
        rocketTableView.frame = view.bounds
        
    }
    

    private func bindingVM() {
        vm.$rockets.sink { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if  !data.isEmpty {
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                    self.loadingLabel.isHidden = true
                    self.rocketTableView.isHidden = false
                    self.rocketTableView.reloadData()
                }
                
            }
        }
        .store(in: &cancellables)
        
        vm.$isRequestTimeout.sink { [weak self] timeout in
            guard let self = self else { return }
            print(timeout)
            if timeout {
                DispatchQueue.main.async {
                    self.loadingIndicator.isHidden = true
                    self.loadingLabel.isHidden = false
                    self.retryButton.isHidden = false
                    self.loadingLabel.text = "Something wrong!!!"
                    self.rocketTableView.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.loadingIndicator.startAnimating()
                    self.loadingIndicator.isHidden = false
                    self.loadingLabel.isHidden = false
                    self.retryButton.isHidden = true
                    self.loadingLabel.text = "Loading..."
                    self.rocketTableView.isHidden = true
                }

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
