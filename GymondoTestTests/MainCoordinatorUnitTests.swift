//
//  MainCoordinatorUnitTests.swift
//  GymondoTestTests
//
//  Created by Dmitry Shtryhel on 28.01.2024.
//

import XCTest
@testable import GymondoTest

final class MainCoordinatorUnitTests: XCTestCase {
    private var coordinator: MainCoordinator!
    private var window: UIWindow!

    override func setUp() {
        super.setUp()
        
        window = UIWindow()
        coordinator = MainCoordinator(window: window)
    }

    override func tearDown() {
        coordinator = nil
        window = nil
        
        super.tearDown()
    }

    // MARK: - openExerciseDetails
    
    func testOpenExerciseDetails_shouldSetChildCoordinator() {
        // When
        coordinator.openExerciseDetails(ExerciseBaseInfo(id: 1, images: [ExerciseImage](), exercises: [Exercise]()))
        
        // Then
        XCTAssertTrue(coordinator.childCoordinator is ExerciseDetailsCoordinator)
    }

}
