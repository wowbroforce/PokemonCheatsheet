//
//  NetworkingService.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain
import RxSwift

final class NetworkingService {
    private let endpoint: String
    private let session: URLSession
    private let decoder = JSONDecoder()

    
    init(endpoint: String, session: URLSession = URLSession.shared) {
        self.endpoint = endpoint
        self.session = session
    }
    
    func getItems<Model: Codable>(path: String) -> Observable<List<Model>> {
        let absolutePath = "\(endpoint)/\(path)?limit=20"
        return self
            .get(absolutePath: absolutePath)
            .map {
                try self.decoder.decode(List<Model>.self, from: $0)
            }
    }
    
    func getItem<Model: Codable>(path: String, name: String) -> Observable<Model> {
        let absolutePath = "\(endpoint)/\(path)/\(name)"
        return self
            .get(absolutePath: absolutePath)
            .map {
                try self.decoder.decode(Model.self, from: $0)
            }
    }
    
    func getImage(url: String) -> Observable<Image> {
        self.get(absolutePath: url)
            .map { data -> Image in
                guard let image = Image(data: data) else {
                    throw Errors.invalidImage
                }
                return image
            }
            
    }
    
    private func get(absolutePath: String) -> Observable<Data> {
         Observable.create { observer in
            guard let url = URL(string: absolutePath) else {
                observer.onError(Errors.invalidUrl(absolutePath))
                return Disposables.create()
            }
            
            let task = self.session.dataTask(with: url) { data, response, error in
                guard error == nil else {
                    observer.onError(Errors.clientError(error!))
                    return
                }
                
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode)
                else {
                    observer.onError(Errors.serverError(response))
                    return
                }
                
                guard let data = data else {
                    observer.onError(Errors.emptyData)
                    return
                }

                observer.onNext(data)
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    enum Errors: Error {
        case invalidUrl(String),
             clientError(Error),
             serverError(URLResponse?),
             emptyData,
             decoding,
             invalidImage
    }
}
