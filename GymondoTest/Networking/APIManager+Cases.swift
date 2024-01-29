//
//  APIManager+Cases.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 22.01.2024.
//

import Moya

typealias Parameters = [String: Any]

enum APIManager {
    case getExerciseCategoryList(Parameters)
}
