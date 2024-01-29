//
//  MainCoordinator.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 19.01.2024.
//

import UIKit

/// `MainCoordinator` is responsible for showing initial screen, depending on the state.
/// For the first time app launch `ExerciseListViewController` will be shown.
final class MainCoordinator: BaseCoordinator {
    // MARK: - Private properties
    
    private let window: UIWindow
    
    // MARK: - Constructor
    
    required init(window: UIWindow) {
        self.window = window
        super.init(presentingViewController: nil)
    }
    
    // MARK: - Public methods
    
    override func startFlow() {
        
        let viewModel = ExerciseListViewModel(service: ExerciseListService())
        let viewController = ExerciseListViewController(viewModel: viewModel)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        presentingViewController = navigationController
        
        viewModel.output.didTapExerciseDetails.drive(onNext:{ [weak self] exerciseInfo in
            guard let exerciseInfo = exerciseInfo else { return }
            self?.openExerciseDetails(exerciseInfo)
        }).disposed(by: viewModel.bag)
    }
    
    override func didFinishChildFlow() {
        super.didFinishChildFlow()
        
        startFlow()
    }
    
}

// MARK: - Public extension

extension MainCoordinator {
    
    func openExerciseDetails(_ exerciseInfo: ExerciseBaseInfo) {
        let coordinator = ExerciseDetailsCoordinator(presentingViewController: presentingViewController, exerciseInfo: exerciseInfo)

        childCoordinator = coordinator
        childCoordinator?.startFlow()
    }
    
}
