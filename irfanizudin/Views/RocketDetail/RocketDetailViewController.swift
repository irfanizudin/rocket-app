//
//  RocketDetailViewController.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import UIKit
import Combine
import SnapKit
import SDWebImage

class RocketDetailViewController: UIViewController {

    let vm = RocketViewModel()
    var rocketId: String = ""
    var cancellables: Set<AnyCancellable> = []
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isHidden = true
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var rocketImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    lazy var rocketName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .label
        label.text = "Falcon"
        return label
    }()
    
    lazy var rocketDescription: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label.withAlphaComponent(0.5)
        label.text = "Falcon is blablabla"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var rocketCostPerLaunch: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label.withAlphaComponent(0.8)
        label.text = "Cost per Launch: $USD 70000"
        return label
    }()
    
    lazy var rocketCountry: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label.withAlphaComponent(0.8)
        label.text = "Country: United States"
        return label
    }()
    
    lazy var rocketFirstFlight: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.textColor = .label.withAlphaComponent(0.8)
        label.text = "First Flight: 2010-10-09"
        return label
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
        title = "Rocket Detail"
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [rocketImage, rocketName, rocketDescription, rocketCostPerLaunch, rocketCountry, rocketFirstFlight]
            .forEach { view in
                contentView.addSubview(view)
            }
        
        setupConstraints()
        
        vm.getRocketDetail(id: rocketId)
        
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
        vm.getRocketDetail(id: rocketId)
        vm.isRequestTimeout = false
    }
    
    private func bindingVM() {
        vm.$rocket.sink { [weak self] data in
            guard let self = self else { return}
            if data != nil {
                DispatchQueue.main.async {
                    self.loadingLabel.isHidden = true
                    self.loadingIndicator.isHidden = true
                    self.scrollView.isHidden = false
                    self.configureRocketImage(url: self.vm.rocket?.flickr_images?.randomElement() ?? "")
                    self.rocketName.text = self.vm.rocket?.name
                    self.rocketDescription.text = self.vm.rocket?.description
                    self.rocketCostPerLaunch.text = "Cost per Launch : USD \(self.vm.rocket?.cost_per_launch ?? 0)"
                    self.rocketCountry.text = "Country: \(self.vm.rocket?.country ?? "")"
                    self.rocketFirstFlight.text = "First Flight: \(self.vm.rocket?.first_flight ?? "xxxx-xx-xx")"
                }
            }
        }
        .store(in: &cancellables)
        
        vm.$isRequestTimeout.sink { [weak self] timeout in
            guard let self = self else { return }
            if timeout {
                DispatchQueue.main.async {
                    self.loadingIndicator.isHidden = true
                    self.loadingLabel.isHidden = false
                    self.loadingLabel.text = "Something wrong!!!"
                    self.retryButton.isHidden = false
                    self.scrollView.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.loadingIndicator.startAnimating()
                    self.loadingIndicator.isHidden = false
                    self.loadingLabel.isHidden = false
                    self.loadingLabel.text = "Loading..."
                    self.retryButton.isHidden = true
                    self.scrollView.isHidden = true
                }

            }
        }
        .store(in: &cancellables)

    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.width.equalTo(scrollView.snp.width)
        }
        
        rocketImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(200)
        }
        
        rocketName.snp.makeConstraints { make in
            make.leading.trailing.equalTo(rocketImage)
            make.top.equalTo(rocketImage.snp.bottom).offset(20)
        }
        
        rocketDescription.snp.makeConstraints { make in
            make.leading.trailing.equalTo(rocketImage)
            make.top.equalTo(rocketName.snp.bottom).offset(10)
        }
        
        rocketCostPerLaunch.snp.makeConstraints { make in
            make.leading.trailing.equalTo(rocketImage)
            make.top.equalTo(rocketDescription.snp.bottom).offset(10)
        }
        
        rocketCountry.snp.makeConstraints { make in
            make.leading.trailing.equalTo(rocketImage)
            make.top.equalTo(rocketCostPerLaunch.snp.bottom).offset(10)
        }
        
        rocketFirstFlight.snp.makeConstraints { make in
            make.leading.trailing.equalTo(rocketImage)
            make.top.equalTo(rocketCountry.snp.bottom).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }

    func configureRocketImage(url: String) {
        guard let url = URL(string: url) else { return }
        rocketImage.sd_imageIndicator = SDWebImageActivityIndicator()
        rocketImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
}
