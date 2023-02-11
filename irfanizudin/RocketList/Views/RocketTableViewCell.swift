//
//  RocketTableViewCell.swift
//  irfanizudin
//
//  Created by Irfan Izudin on 11/02/23.
//

import UIKit
import SnapKit
import SDWebImage

class RocketTableViewCell: UITableViewCell {

    static let identifier = "RocketTableViewCell"
    
    lazy var rocketImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 25
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
        label.text = "Falcon is dmkdkasmdknsnadnsa"
        label.numberOfLines = 1
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [rocketImage, rocketName, rocketDescription].forEach { view in
            contentView.addSubview(view)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        rocketImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(20)
            make.width.height.equalTo(50)
        }
        
        rocketName.snp.makeConstraints { make in
            make.top.equalTo(rocketImage.snp.top)
            make.leading.equalTo(rocketImage.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        rocketDescription.snp.makeConstraints { make in
            make.top.equalTo(rocketName.snp.bottom).offset(10)
            make.leading.trailing.equalTo(rocketName)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureRocketImage(url: String) {
        guard let url = URL(string: url) else { return }
        rocketImage.sd_imageIndicator = SDWebImageActivityIndicator()
        rocketImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
    
    
}
