//
//  NetworkManager.swift
//  GymondoTest
//
//  Created by Dmitry Shtryhel on 22.01.2024.
//

import Moya
import RxSwift

/// `NetworkManager` is responsible for executing network request.
final class NetworkManager {
    
    private let networkProvider: MoyaProvider<APIManager>
    
    init() {
        
        networkProvider = MoyaProvider<APIManager>()
    }
    
    func request<T: Codable>(with token: APIManager) -> Observable<T> {
        return Observable.create { observer in
            return self.networkProvider.rx.request(token).subscribe(onSuccess: { response in
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let entity = try decoder.decode(MainResponse<T>.self, from: response.data)
                    if response.data.isEmpty {
                        observer.onCompleted()
                    } else if let results = entity.results {
                        observer.onNext(results)
                    }
                } catch (let error) {
                    observer.onError(error)
                }
            }, onFailure: { error in
                observer.onError(error)
            })
        }
        
    }
    
}
