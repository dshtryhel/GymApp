//
//  ExerciseDetailsViewModel.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 20.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

struct ExerciseDetailsViewModelInput {
    let didSelectExerciseDescription: AnyObserver<Int>
}

struct ExerciseDetailsViewModelOutput {
    let exerciseName: Driver<String?>
    let showVariationCells: Driver<[VariationCellViewModel]>
    let showExerciseCells: Driver<[ExerciseTableCellViewModel]>
    let didTapExerciseDescription: Driver<Exercise?>
}

protocol ExerciseDetailsViewModelProtocol {
    var input: ExerciseDetailsViewModelInput { get }
    var output: ExerciseDetailsViewModelOutput { get }
    var bag: DisposeBag { get }
}

final class ExerciseDetailsViewModel: ExerciseDetailsViewModelProtocol {

    // MARK: - Public properties
    let input: ExerciseDetailsViewModelInput
    let output: ExerciseDetailsViewModelOutput
    let bag = DisposeBag()
    
    // MARK: - Input
    private let didSelectExerciseDescriptionSubject = PublishSubject<Int>()
    
    // MARK: - Output
    private let exerciseNameSubject = BehaviorSubject<String?>(value: nil)
    private let showVariationCellsSubject = BehaviorSubject<[VariationCellViewModel]>(value: [VariationCellViewModel]())
    private let showExerciseCellsSubject = BehaviorSubject<[ExerciseTableCellViewModel]>(value: [ExerciseTableCellViewModel]())
    private let didTapExerciseDescriptionSubject = PublishSubject<Exercise?>()
    
    // MARK: - Private properties
    
    private var exerciseDetailsInfo = [Exercise]()
    
    init(exerciseBaseInfo: ExerciseBaseInfo) {
        
        input = ExerciseDetailsViewModelInput(
                                              didSelectExerciseDescription: didSelectExerciseDescriptionSubject.asObserver()
        )
        
        output = ExerciseDetailsViewModelOutput(
                                                exerciseName: exerciseNameSubject.asDriver(onErrorJustReturn: nil),
                                                showVariationCells: showVariationCellsSubject.asDriver(onErrorJustReturn: [VariationCellViewModel]()),
                                                showExerciseCells: showExerciseCellsSubject.asDriver(onErrorJustReturn: [ExerciseTableCellViewModel]()), didTapExerciseDescription: didTapExerciseDescriptionSubject.asDriver(onErrorJustReturn: nil)
        )
        
        exerciseDetailsInfo = exerciseBaseInfo.exercises
        
        exerciseNameSubject.onNext(exerciseBaseInfo.exercises.first?.name)
        
        makeCellModels(exerciseBaseInfo)
        
        makeSubscriptions()
    }
    
}

// MARK: - Private extensions

private extension ExerciseDetailsViewModel {
    
    func makeSubscriptions() {
        
        didSelectExerciseDescriptionSubject.subscribe(onNext: { [weak self] row in
            
            self?.didTapExerciseDescriptionSubject.onNext(self?.exerciseDetailsInfo[row])
        }).disposed(by: bag)
        
    }
    
    func makeCellModels(_ exerciseBaseInfo: ExerciseBaseInfo) {
        var variationsCellModels = exerciseBaseInfo.images.map { VariationCellViewModel(image: $0.image) }
        
        if variationsCellModels.isEmpty {
            variationsCellModels = [VariationCellViewModel(image: nil)]
        }
        
        showVariationCellsSubject.onNext(variationsCellModels)
        
        let exerciseCellModels = exerciseBaseInfo.exercises
            .map { ExerciseTableCellViewModel(name: $0.name) }
        
        showExerciseCellsSubject.onNext(exerciseCellModels)
    }
    
}
