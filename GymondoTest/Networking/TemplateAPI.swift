//
//  TemplateAPI.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 22.01.2024.
//

import RxSwift

protocol TemplateAPI {
    var bag: DisposeBag { get }
    var manager: NetworkManager { get }
}
