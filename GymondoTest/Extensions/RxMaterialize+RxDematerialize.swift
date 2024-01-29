//
//  RxMaterialize+RxDematerialize.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 23.01.2024.
//

import RxSwift

extension ObservableType where Element: EventConvertible {
    
    func elements() -> Observable<Element.Element> {
        compactMap { $0.event.element }
    }
    
}
