//
//  ExerciseListViewModel.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 19.01.2024.
//

import UIKit
import RxSwift
import RxCocoa

struct ExerciseListViewModelInput {
    let getList: AnyObserver<Void>
    let didSelectExercise: AnyObserver<Int>
}

struct ExerciseListViewModelOutput {
    let showCells: Driver<[ExerciseCellViewModel]>
    let progress: Driver<Bool>
    let error: Driver<String>
    let didTapExerciseDetails: Driver<ExerciseBaseInfo?>
}

protocol ExerciseListViewModelProtocol {
    var input: ExerciseListViewModelInput { get }
    var output: ExerciseListViewModelOutput { get }
    var bag: DisposeBag { get }
}

final class ExerciseListViewModel: ExerciseListViewModelProtocol {
    
    // MARK: - Public properties
    let input: ExerciseListViewModelInput
    let output: ExerciseListViewModelOutput
    let bag = DisposeBag()
    
    // MARK: - Input
    private let getListSubject = PublishSubject<Void>()
    private let didSelectExerciseSubject = PublishSubject<Int>()
    
    // MARK: - Output
    private let loadingSubject = BehaviorSubject<Bool>(value: false)
    private let showCellsSubject = PublishSubject<[ExerciseCellViewModel]>()
    private let didTapExerciseDetailsSubject = PublishSubject<ExerciseBaseInfo?>()
    private let errorSubject = PublishSubject<String>()
    
    // MARK: - Private properties
    private var exerciseBaseInfo = [ExerciseBaseInfo]()
    
    init(service: ExerciseListServiceProtocol) {
        
        input = ExerciseListViewModelInput(
            getList: getListSubject.asObserver(),
            didSelectExercise: didSelectExerciseSubject.asObserver()
        )
        
        output = ExerciseListViewModelOutput(
            showCells: showCellsSubject.asDriver(onErrorJustReturn:            [ExerciseCellViewModel]()),
            progress: loadingSubject.asDriver(onErrorJustReturn: false),
            error: errorSubject.asDriver(onErrorJustReturn: ""),
            didTapExerciseDetails: didTapExerciseDetailsSubject.asDriver(onErrorJustReturn: nil)
        )
        
        getExerciseInfoList(service)
        
        makeSubscriptions()
    }
    
}

// MARK: - Private extensions

private extension ExerciseListViewModel {
    
    func makeSubscriptions() {
        
        didSelectExerciseSubject.subscribe(onNext: { [weak self] row in
            
            self?.didTapExerciseDetailsSubject.onNext(self?.exerciseBaseInfo[row])
        }).disposed(by: bag)
        
    }
    
    func getExerciseInfoList(_ service: ExerciseListServiceProtocol) {
        loadingSubject.onNext(true)
        
        let getExerciseInfoListEvent = getListSubject
            .flatMap {
                return service.getExerciseBaseInfo().materialize()
            }.share()
        
        getExerciseInfoListEvent.subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated)).elements()
            .subscribe(onNext: { [weak self] value in
                self?.loadingSubject.onNext(false)
                self?.exerciseBaseInfo = value
                self?.createCellModels(from: value)
            }).disposed(by: bag)
        
        getExerciseInfoListEvent.compactMap { $0.event.error?.localizedDescription }
            .subscribe(onNext: { [weak self] error in
                self?.errorSubject.onNext(error)
                self?.loadingSubject.onNext(false)
            }).disposed(by: bag)
    }
    
    func createCellModels(from value: [ExerciseBaseInfo]) {
        
        let cellModels = value.map { exerciseBase -> ExerciseCellViewModel in
            var image: URL?
            exerciseBase.images.forEach {
                if $0.isMain {
                    image = $0.image
                }
            }
            
            return ExerciseCellViewModel(name: exerciseBase.exercises.first?.name ?? "", image: image)
        }
        
        showCellsSubject.onNext(cellModels)
    }
    
}
