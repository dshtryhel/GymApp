//
//  ExerciseDetailsViewController.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 20.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ExerciseDetailsViewController: UIViewController {
    
    // MARK: - Private properties
    
    lazy private var variationsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentMode = .scaleToFill
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .beautyBush
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    lazy private var exercisesTableView: UITableView = {
        let tableView = UITableView()
        tableView.contentMode = .scaleToFill
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .beautyBush
        tableView.clipsToBounds = false
        return tableView
    }()
    
    lazy private var exerciseLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    private let viewModel: ExerciseDetailsViewModelProtocol
    
    private struct LocalConstants {
        static let exercisesTitle = "EXERCISES"
        static let cellsPerRow: CGFloat = 3
        static let sidesInset: CGFloat = 20
        static let heightProportionality = 1.2
        static let exerciseString = "Exercise"
    }
    
    // MARK: - Constructor
    
    init(viewModel: ExerciseDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle:nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupSignals()
    }
    
}

// MARK: - Public extensions

extension ExerciseDetailsViewController {
    
    override func setupViews() {
        exerciseLabel.text = LocalConstants.exercisesTitle
        view.backgroundColor = .beautyBush
        
        setupTableView()
        setupCollectionView()
        
        view.addSubview(exerciseLabel)
        view.addSubview(variationsCollectionView)
        view.addSubview(exercisesTableView)
        
        let collectionViewConstraints = [
            variationsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            variationsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            variationsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            variationsCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let tableViewConstraints = [
            exercisesTableView.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 15),
            exercisesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            exercisesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: exercisesTableView.bottomAnchor)
        ]
        
        let exerciseLabelConstraints = [
            exerciseLabel.topAnchor.constraint(equalTo: variationsCollectionView.bottomAnchor, constant: 10),
            exerciseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        let activeConstraints = collectionViewConstraints + tableViewConstraints + exerciseLabelConstraints
        
        NSLayoutConstraint.activate(activeConstraints)
    }
    
    override func setupSignals() {
        
        viewModel.output.exerciseName.drive(onNext: { [weak self] title in
            self?.setupNavigationBar(with: title ?? LocalConstants.exerciseString)
        }).disposed(by: viewModel.bag)
        
        variationsCollectionView.rx.setDelegate(self).disposed(by: viewModel.bag)
        
        viewModel.output.showVariationCells
            .drive(variationsCollectionView.rx.items(
                cellIdentifier: VariationCollectionViewCell.identifier,
                cellType: VariationCollectionViewCell.self)) { (_, element, cell) in
                    return cell.configure(with: element)
                }.disposed(by: viewModel.bag)
        
        viewModel.output.showExerciseCells
            .drive(exercisesTableView.rx.items(
                cellIdentifier: ExerciseTableViewCell.identifier,
                cellType: ExerciseTableViewCell.self)) { (_, element, cell) in
                    return cell.configure(with: element)
                }.disposed(by: viewModel.bag)
        
        exercisesTableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.didSelectExerciseDescription)
            .disposed(by: viewModel.bag)
        
    }
    
}

// MARK: - Private extensions

private extension ExerciseDetailsViewController {
    
    func setupCollectionView() {
        
        variationsCollectionView.allowsSelection = false
        variationsCollectionView.register(VariationCollectionViewCell.self, forCellWithReuseIdentifier: VariationCollectionViewCell.identifier)
    }
    
    func setupTableView() {
        
        exercisesTableView.register(ExerciseTableViewCell.self, forCellReuseIdentifier: ExerciseTableViewCell.identifier)
        exercisesTableView.separatorStyle = .none
        exercisesTableView.rowHeight = 60
    }
    
    func setupNavigationBar(with title: String) {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        label.text = title
        label.textColor = .black
        label.sizeToFit()
        label.textAlignment = .center
        
        navigationItem.titleView = label

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backArrow")?.withTintColor(.salmon), style: .plain, target: self, action: #selector(closeView))
    }
    
    @objc func closeView() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExerciseDetailsViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExerciseDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let cellWidth = (screenWidth - LocalConstants.sidesInset) / LocalConstants.cellsPerRow
        let cellHeight = cellWidth * LocalConstants.heightProportionality
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
