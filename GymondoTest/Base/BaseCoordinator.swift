//
//  BaseCoordinator.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 19.01.2024.
//

import UIKit

/// The `BaseCoordinator` class provides the basic implementation to start and finish a navigation flow.
/// Its responsibility is to manage the presentation logic of view controllers.
/// Subclasses can inherit this class to implement their specific presentation logic in `startFlow` method.
class BaseCoordinator: NSObject {
    var presentingViewController: UIViewController?

    /// A child flow coordinator started from this flow.
    var childCoordinator: BaseCoordinator? {
        didSet {
            childCoordinator?.parentCoordinator = self
        }
    }

    /// The parent flow coordinator that started this flow.
    weak var parentCoordinator: BaseCoordinator?

    /// Create a new coordinator object with the view controller presenting this new navigation flow.
    ///
    /// - Parameter presentingViewController: The view controller presenting this flow.
    init(presentingViewController: UIViewController?) {
        self.presentingViewController = presentingViewController
    }
    
    /// Presents first view controller of the flow.
    func startFlow() {
        // Subclasses can implement this method to create and display the first view controller of the flow.
    }
    
    /// Informs the parent coordinator, that its child finished.
    func didFinishChildFlow() {
        childCoordinator = nil
    }
    
    /// Call this method to dismiss the view controllers involved in this flow.
    func finishFlow() {
        presentingViewController?.dismiss(animated: true) { [weak self] in
            self?.parentCoordinator?.didFinishChildFlow()
        }
    }
}

