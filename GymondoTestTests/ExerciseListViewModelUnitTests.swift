//
//  ExerciseListViewModelUnitTests.swift
//  GymondoTestTests
//
//  Created by Dmitry Shtryhel on 28.01.2024.
//

import XCTest
import RxSwift
@testable import GymondoTest

final class ExerciseListViewModelUnitTests: XCTestCase {

    private var viewModel: ExerciseListViewModelProtocol!
    private var serviceFake: FakeExerciseListService!
    private let exerciseBaseInfo = ExerciseBaseInfo(
        id: 1,
        images: [ExerciseImage(image: URL(string: "gymondo.com")!,
        isMain: true)],
        exercises: [Exercise(id: 1, name: "Title", description: "Text")]
    )
    private let error = NSError(domain: "FakeErrorDomain", code: 123, userInfo: nil)
    
    override func setUp() {
        super.setUp()
        serviceFake = FakeExerciseListService()
        viewModel = ExerciseListViewModel(service: serviceFake)
    }

    override func tearDown() {
        viewModel = nil
        
        super.tearDown()
    }
    
    func testGetListWithSuccessfulResponse() {
        let expectation = self.expectation(description: "Wait for successful response")
        serviceFake.fakeData = [exerciseBaseInfo]
        
        viewModel.output.showCells.drive(onNext: { [weak self] value in
            XCTAssertEqual(value.first?.name, self?.exerciseBaseInfo.exercises.first?.name)
            XCTAssertEqual(value.first?.image?.absoluteString, self?.exerciseBaseInfo.images.first?.image.absoluteString)
            expectation.fulfill()
        }).disposed(by: viewModel.bag)
        
        
        viewModel.input.getList.onNext(())
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetListWithFailedResponse() {
        let expectation = self.expectation(description: "Wait for failed response")
        serviceFake.error = error
        
        viewModel.output.error.drive(onNext: { error in
            expectation.fulfill()
        }).disposed(by: viewModel.bag)
        
        
        viewModel.input.getList.onNext(())
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testDidSelectExercise() {
        let expectation = self.expectation(description: "Exercise did tap")
        serviceFake.fakeData = [exerciseBaseInfo]
        
        viewModel.output.didTapExerciseDetails.drive(onNext: { [weak self] value in
            XCTAssertEqual(value?.exercises.first?.name, self?.exerciseBaseInfo.exercises.first?.name)
            XCTAssertEqual(value?.images.first?.image.absoluteString, self?.exerciseBaseInfo.images.first?.image.absoluteString)
            expectation.fulfill()
        }).disposed(by: viewModel.bag)
        
        viewModel.input.getList.onNext(())
        
        viewModel.input.didSelectExercise.onNext(0)
        
        wait(for: [expectation], timeout: 1)
    }

}

final class FakeExerciseListService: ExerciseListServiceProtocol {
    
    let manager = NetworkManager()
    let bag = DisposeBag()
    
    var fakeData: [ExerciseBaseInfo] = []
    var error: Error?
    
    func getExerciseBaseInfo() -> Observable<[ExerciseBaseInfo]> {
        if let error = error {
            return Observable<[ExerciseBaseInfo]>.error(error)
        } else {
            return Observable.just(fakeData)
        }
        
    }
    
}
