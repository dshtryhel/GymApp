//
//  ExerciseDetailsCoordinator.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 24.01.2024.
//

import UIKit

final class ExerciseDetailsCoordinator: BaseCoordinator {
    
    // MARK: - Private properties
    
    private let exerciseInfo: ExerciseBaseInfo
    
    // MARK: - Constructor
    
    init(presentingViewController: UIViewController?, exerciseInfo: ExerciseBaseInfo) {
        self.exerciseInfo = exerciseInfo
        super.init(presentingViewController: presentingViewController)
    }

    // MARK: - Public methods
    
    override func startFlow() {
        
        let viewModel = ExerciseDetailsViewModel(exerciseBaseInfo: exerciseInfo)
        let viewController = ExerciseDetailsViewController(viewModel: viewModel)
        
        presentingViewController?.show(viewController, sender: nil)
        
        viewModel.output.didTapExerciseDescription.drive(onNext:{ [weak self] exerciseDescription in
            guard let exerciseDescription = exerciseDescription else { return }
            self?.openExerciseDescriptionCoordinator(exerciseDescription)
        }).disposed(by: viewModel.bag)
    }
    
    
}

// MARK: - Private extension

private extension ExerciseDetailsCoordinator {
    
    func openExerciseDescriptionCoordinator(_ exercise: Exercise) {
        let coordinator = ExerciseDescriptionCoordinator(presentingViewController: presentingViewController, exerciseInfo: exercise)

        childCoordinator = coordinator
        childCoordinator?.startFlow()
    }
    
}
