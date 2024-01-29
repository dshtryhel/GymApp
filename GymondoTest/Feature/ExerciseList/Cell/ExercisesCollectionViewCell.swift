//
//  ExerciseCollectionViewCell.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 22.01.2024.
//

import UIKit
import UIKit

final class ExercisesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    static let identifier = String(describing: ExercisesCollectionViewCell.self)
    
    // MARK: - Private properties
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "placeholderImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11)
        label.textColor = .white
        return label
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    // MARK: - Public methods
    
    func configure(with viewModel: ExerciseCellViewModel) {
        
        nameLabel.text = viewModel.name
        if let urlImage = viewModel.image {
            imageView.loadFromURL(url: urlImage)
            imageView.contentMode = .scaleToFill
        } else {
            imageView.contentMode = .center
            imageView.image = placeholderImage
        }
        
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ]
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 140)
        ]
        
        let activeConstraints = nameLabelConstraints + imageViewConstraints
        
        NSLayoutConstraint.activate(activeConstraints)
        
        contentView.backgroundColor = .salmon
        contentView.layer.cornerRadius = cornerRadius
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        setupShadow()
    }
    
    private func setupShadow() {
        let path = UIBezierPath(
            roundedRect: contentView.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        contentView.layer.shadowPath = path.cgPath
        contentView.layer.shadowOffset = CGSize(width: 0, height: -1)
        contentView.layer.shadowRadius = 6.0
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
    }
    
}
