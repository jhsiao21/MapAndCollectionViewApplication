//
//  CollectionViewCell.swift
//  MapApplication
//
//  Created by LoganMacMini on 2024/4/7.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "CollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 15.0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let locationTitle: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let locationSubtitle: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let scheduleBtn: UIButton = {
        var configuration = UIButton.Configuration.filled() // 創建一個具有透明背景的按鈕配置
        configuration.baseForegroundColor = .white // 設置前景色為白色（用於文字和圖標）
        configuration.baseBackgroundColor = .systemOrange // 設置背景色為系統橘色
        configuration.buttonSize = .small
        configuration.image = UIImage(systemName: "plus") // 設置圖標為系統加號圖標
        configuration.imagePlacement = .leading // 圖標放在文字前面
        var attributes = AttributeContainer()
        attributes.foregroundColor = .white // 設置文字顏色為白色
        configuration.attributedTitle = AttributedString("行程", attributes: attributes) // 設置按鈕的主標題為「行程」
        configuration.titleAlignment = .center // 標題對齊方式為居中
        configuration.imagePadding = 5 // 圖標和文字之間的間距
        let button = UIButton(configuration: configuration, primaryAction: nil)
        // button.addTarget(self, action: #selector(shareBtnTapped), for: .touchUpInside) // 添加按鈕點擊事件
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        
        return button
    }()
    
    private let hStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let vStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func layout() {
        
        hStack.addArrangedSubview(imageView)
        
        vStack.addArrangedSubview(locationTitle)
        vStack.addArrangedSubview(locationSubtitle)
        vStack.addArrangedSubview(UIView())
        vStack.addArrangedSubview(scheduleBtn)
        
        hStack.addArrangedSubview(vStack)
        contentView.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalToConstant: 130),
            imageView.heightAnchor.constraint(equalToConstant: 130),
            
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
        ])
    }
    
    public func configure(image: UIImage, title: String, subtitle: String) {
        imageView.image = image
        locationTitle.text = title
        locationSubtitle.text = subtitle
    }
}
