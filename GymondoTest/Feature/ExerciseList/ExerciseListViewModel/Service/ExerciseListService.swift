//
//  ExerciseListService.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 23.01.2024.
//

import RxSwift

protocol ExerciseListServiceProtocol: TemplateAPI {
    func getExerciseBaseInfo() -> Observable<[ExerciseBaseInfo]>
}

final class ExerciseListService: ExerciseListServiceProtocol {
    
    let manager: NetworkManager
    let bag = DisposeBag()
    
    private let activity = PublishSubject<Bool>()
    
    private struct Constants {
        static let englishLanguageID = 2
    }
    
    init() {
        manager = NetworkManager()
    }
    
    func getExerciseBaseInfo() -> Observable<[ExerciseBaseInfo]> {
        let parameters: [String : Any] = [
            "language": Constants.englishLanguageID
        ]
        
        return manager.request(with: .getExerciseCategoryList(parameters))
    }
}
