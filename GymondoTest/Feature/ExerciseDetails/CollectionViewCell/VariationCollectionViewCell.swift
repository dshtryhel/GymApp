//
//  VariationCollectionViewCell.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 24.01.2024.
//

import UIKit

final class VariationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    static let identifier = String(describing: VariationCollectionViewCell.self)

    // MARK: - Private properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let placeholderImage = UIImage(named: "placeholderImage")
    private let cornerRadius = 15.0
    
    // MARK: - Constructor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private methods
    
    private func setupView() {
        contentView.addSubview(imageView)
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        
        contentView.layer.cornerRadius = cornerRadius
        imageView.layer.cornerRadius = cornerRadius
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
    }
    
    // MARK: - Public methods
    
    func configure(with viewModel: VariationCellViewModel) {
        
        if let imageURL = viewModel.image {
            imageView.loadFromURL(url: imageURL)
            imageView.contentMode = .scaleToFill
            contentView.backgroundColor = .clear
        } else {
            imageView.image = placeholderImage
            imageView.contentMode = .center
            contentView.backgroundColor = .white
        }
        
    }

}
