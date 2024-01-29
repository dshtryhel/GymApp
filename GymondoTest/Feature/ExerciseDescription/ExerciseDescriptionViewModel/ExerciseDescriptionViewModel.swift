//
//  ExerciseDescriptionViewModel.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 27.01.2024.
//

import UIKit

final class ExerciseDescriptionViewModel: ObservableObject {

    @Published private(set) var title: String
    @Published private(set) var description: String
    
    init(exerciseInfo: Exercise) {
        self.title = exerciseInfo.name
        self.description = exerciseInfo.description
    }
    
}
