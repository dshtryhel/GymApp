//
//  ExerciseDescriptionCoordinator.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 27.01.2024.
//

import UIKit
import SwiftUI

final class ExerciseDescriptionCoordinator: BaseCoordinator {
    
    // MARK: - Private properties
    
    private let exerciseInfo: Exercise
    
    // MARK: - Constructor
    
    init(presentingViewController: UIViewController?, exerciseInfo: Exercise) {
        self.exerciseInfo = exerciseInfo
        super.init(presentingViewController: presentingViewController)
    }

    // MARK: - Public methods
    
    override func startFlow() {
        
        let viewModel = ExerciseDescriptionViewModel(exerciseInfo: exerciseInfo)
        let viewController = UIHostingController(rootView: ExerciseDescriptionView(viewModel: viewModel))
        presentingViewController?.show(viewController, sender: nil)
        
    }
    
}
