//
//  ExerciseDetailsViewModelUnitTests.swift
//  GymondoTestTests
//
//  Created by Dmitry Shtryhel on 28.01.2024.
//

import XCTest
@testable import GymondoTest

final class ExerciseDetailsViewModelUnitTests: XCTestCase {
    
    private var viewModel: ExerciseDetailsViewModelProtocol!
    private let exerciseBaseInfo = ExerciseBaseInfo(
        id: 1,
        images: [ExerciseImage(image: URL(string: "gymondo.com")!,
        isMain: true)],
        exercises: [Exercise(id: 1, name: "Title", description: "Text")]
    )

    override func setUp() {
        super.setUp()
        
        viewModel = ExerciseDetailsViewModel(exerciseBaseInfo: exerciseBaseInfo)
    }

    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    func testEmitShowExerciseTitle() {
        let expectation = self.expectation(description: "Wait for show correct title exercise")
        
        viewModel.output.exerciseName.drive(onNext: { [weak self] value in
            XCTAssertEqual(value, self?.exerciseBaseInfo.exercises.first?.name)
            expectation.fulfill()
        }).disposed(by: viewModel.bag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testInitEmitShowExerciseCellsEvent() {
        let expectation = self.expectation(description: "Wait for successful show exercise cells")
        
        viewModel.output.showExerciseCells.drive(onNext: { [weak self] value in
            XCTAssertEqual(value.first?.name, self?.exerciseBaseInfo.exercises.first?.name)
            expectation.fulfill()
        }).disposed(by: viewModel.bag)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testInitEmitShowVariationCellsEvent() {
        let expectation = self.expectation(description: "Wait for successful show variation cells")
        
        viewModel.output.showVariationCells.drive(onNext: { [weak self] value in
            XCTAssertEqual(value.first?.image?.absoluteString, self?.exerciseBaseInfo.images.first?.image.absoluteString)
            expectation.fulfill()
        }).disposed(by: viewModel.bag)
        
        wait(for: [expectation], timeout: 1)
    }

    func testDidTapExerciseDescription() {
        let expectation = self.expectation(description: "Exercise description did tap")
        
        viewModel.output.didTapExerciseDescription.drive(onNext: { [weak self] value in
            XCTAssertEqual(value?.name, self?.exerciseBaseInfo.exercises.first?.name)
            XCTAssertEqual(value?.description, self?.exerciseBaseInfo.exercises.first?.description)
            expectation.fulfill()
        }).disposed(by: viewModel.bag)
        
        viewModel.input.didSelectExerciseDescription.onNext(0)
        
        wait(for: [expectation], timeout: 1)
    }

}
