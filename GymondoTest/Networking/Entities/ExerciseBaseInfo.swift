//
//  ExerciseBaseInfo.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 22.01.2024.
//

import Foundation

struct ExerciseBaseInfo: Codable {
    let id: Int
    let images: [ExerciseImage]
    let exercises: [Exercise]
}

struct ExerciseImage: Codable {
    let image: URL
    let isMain: Bool
}

struct Exercise: Codable {
    let id: Int
    let name: String
    let description: String
}
