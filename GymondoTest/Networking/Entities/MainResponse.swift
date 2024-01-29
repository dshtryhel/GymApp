//
//  MainResponse.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 24.01.2024.
//

import Foundation

struct MainResponse<T: Codable>: Codable {
    let results: T?
}
