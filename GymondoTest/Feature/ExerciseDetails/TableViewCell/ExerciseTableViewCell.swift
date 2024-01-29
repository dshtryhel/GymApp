//
//  ExerciseTableViewCell.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 24.01.2024.
//

import UIKit

final class ExerciseTableViewCell: UITableViewCell {

    // MARK: - Public properties
    
    static let identifier = String(describing: ExerciseTableViewCell.self)
    static let nibName = UINib(nibName: ExerciseTableViewCell.identifier, bundle: nil)
    
    // MARK: - Private properties
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let cornerRadius = 11.0
    
    // MARK: - Constructor
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margins = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.layer.cornerRadius = cornerRadius
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.backgroundColor = .salmon
        contentView.addSubview(nameLabel)
        
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -11),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
        
        setupShadow()
    }
    
    private func setupShadow() {
        contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        contentView.layer.shadowColor = UIColor.darkGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 5.0
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // MARK: - Public methods
    
    func configure(with viewModel: ExerciseTableCellViewModel) {
        nameLabel.text = viewModel.name
    }
}
