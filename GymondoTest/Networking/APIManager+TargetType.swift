//
//  APIManager+TargetType.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 22.01.2024.
//

import Moya

extension APIManager: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://wger.de/api/v2")!
    }
    
    var path: String {
        switch self {
        case .getExerciseCategoryList:
            return "/exercisebaseinfo"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getExerciseCategoryList(let dictionary):
            return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
        return [String: String]()
    }
    
}
