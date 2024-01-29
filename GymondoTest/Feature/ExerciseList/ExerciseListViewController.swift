//
//  ExerciseListViewController.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 19.01.2024.
//

import UIKit

final class ExerciseListViewController: UIViewController {
    
    // MARK: - Private properties
    
    lazy private var exercisesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentMode = .scaleToFill
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .beautyBush
        collectionView.clipsToBounds = false
        
        return collectionView
    }()
    
    private let viewModel: ExerciseListViewModelProtocol
    private let customAlert = CustomAlert()
    
    private struct LocalConstants {
        static let cellsPerRow: CGFloat = 2
        static let sidesInset: CGFloat = 20
        static let heightProportionality = 1.3
        static let title = "Gymondo"
        static let errorTitle = "Error"
    }
    
    // MARK: - Constructor
    
    init(viewModel: ExerciseListViewModelProtocol) {
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

extension ExerciseListViewController {
    
    override func setupViews() {
        navigationController?.navigationBar.topItem?.title = LocalConstants.title
        view.backgroundColor = .beautyBush
        
        setupCollectionView()
    }
    
    override func setupSignals() {
        
        viewModel.input.getList.onNext(())
        
        viewModel.output.progress
            .drive(progressHud.rx.animation)
            .disposed(by: viewModel.bag)
        
        exercisesCollectionView.rx.setDelegate(self).disposed(by: viewModel.bag)
        
        viewModel.output.showCells
            .drive(exercisesCollectionView.rx.items(
                cellIdentifier: ExercisesCollectionViewCell.identifier,
                cellType: ExercisesCollectionViewCell.self)) { (_, element, cell) in
                    return cell.configure(with: element)
                }.disposed(by: viewModel.bag)
        
        exercisesCollectionView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.input.didSelectExercise)
            .disposed(by: viewModel.bag)
        
        viewModel.output.error
            .drive(onNext: { [weak self] error in
                self?.showError(error: error)
            }).disposed(by: viewModel.bag)
        
    }
    
}

// MARK: - Private extensions

private extension ExerciseListViewController {
    
    func setupCollectionView() {
        
        exercisesCollectionView.register(ExercisesCollectionViewCell.self, forCellWithReuseIdentifier: ExercisesCollectionViewCell.identifier)
        
        view.addSubview(exercisesCollectionView)
        
        let collectionViewConstraints = [
            exercisesCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 33),
            exercisesCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -33),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo:exercisesCollectionView.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: exercisesCollectionView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
        
    }
    
    func showError(error: String) {
        customAlert.showAlert(with: LocalConstants.errorTitle, message: error, on: self)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExerciseListViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExerciseListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.width
        let cellWidth = (screenWidth - LocalConstants.sidesInset) / LocalConstants.cellsPerRow
        let cellHeight = cellWidth * LocalConstants.heightProportionality
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
