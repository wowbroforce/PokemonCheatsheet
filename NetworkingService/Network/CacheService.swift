//
//  CacheService.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import RxSwift
import Domain

protocol Cacheable {
    var cacheIdintifier: String { get }
}

protocol AbstractCache {
    func save<T: Codable & Cacheable>(object: T) -> Completable
    func save<T: Codable>(object: T) -> Completable
    func save(image: Image, path: String) -> Completable
    func fetch<T: Codable>(by id: String) -> Maybe<T>
    func fetch<T: Codable>() -> Maybe<T>
    func fetchImage(by path: String) -> Maybe<Image>
}

final class Cache: AbstractCache {
    private let scheduler: SerialDispatchQueueScheduler
    private let fileManager: FileManager
    private let path: String
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(
        scheduler: SerialDispatchQueueScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "com.wowbroforce.Network.Cache"),
        fileManager: FileManager = .default,
        path: String
    ) {
        self.fileManager = fileManager
        self.scheduler = scheduler
        self.path = path
    }

    func save<T: Codable & Cacheable>(object: T) -> Completable {
        Completable.create { observer in
            guard let root = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                observer(.completed)
                return Disposables.create()
            }
            let url = root
                .appendingPathComponent(self.path)
                .appendingPathComponent("\(object.cacheIdintifier)")
                .appendingPathComponent("\(T.self).cache")

            do {
                try self.createFolders(at: url)
                let data = try self.encoder.encode(object)
                try data.write(to: url, options: .atomic)
            } catch {
                observer(.completed)
                return Disposables.create()
            }
            observer(.completed)
            return Disposables.create()
        }.subscribe(on: scheduler)
    }
    
    func save<T: Codable>(object: T) -> Completable {
        Completable.create { observer in
            guard let root = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                observer(.completed)
                return Disposables.create()
            }
            let url = root
                .appendingPathComponent(self.path)
                .appendingPathComponent("\(T.self).cache")
            do {
                try self.createFolders(at: url)
                let data = try self.encoder.encode(object)
                try data.write(to: url, options: .atomic)
            } catch {
                observer(.completed)
                return Disposables.create()
            }
            observer(.completed)
            return Disposables.create()
        }.subscribe(on: scheduler)
    }
    
    func save(image: Image, path: String) -> Completable {
        Completable.create { observer in
            guard
                let root = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
                let pathUrl = URL(string: path)
            else {
                observer(.completed)
                return Disposables.create()
            }
            
            let newPath = pathUrl.pathComponents.filter { $0 != "/" }.joined(separator: "/")

            let url = root
                .appendingPathComponent(newPath)

            guard let data = image.pngData() else {
                observer(.completed)
                return Disposables.create()
            }

            do {
                try self.createFolders(at: url)
                try data.write(to: url, options: .atomic)
            } catch {
                observer(.completed)
                return Disposables.create()
            }
            observer(.completed)
            return Disposables.create()
        }.subscribe(on: scheduler)
    }
    
    func fetch<T: Codable>(by name: String) -> Maybe<T> {
        Maybe.create { observer in
            guard let root = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                observer(.completed)
                return Disposables.create()
            }
            let url = root
                .appendingPathComponent(self.path)
                .appendingPathComponent("\(name)")
                .appendingPathComponent("\(T.self).cache")
            
            guard let data = self.fileManager.contents(atPath: url.path) else {
                observer(.completed)
                return Disposables.create()
            }
            
            do {
                let object = try self.decoder.decode(T.self, from: data)
                observer(.success(object))
                observer(.completed)
            } catch {
                observer(.completed)
                return Disposables.create()
            }
            
            return Disposables.create()
        }.subscribe(on: scheduler)
    }
    
    func fetch<T: Codable>() -> Maybe<T> {
        Maybe.create { observer in
            guard let root = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                observer(.completed)
                return Disposables.create()
            }
            let url = root
                .appendingPathComponent(self.path)
                .appendingPathComponent("\(T.self).cache")
            
            guard let data = self.fileManager.contents(atPath: url.path) else {
                observer(.completed)
                return Disposables.create()
            }
            
            do {
                let object = try self.decoder.decode(T.self, from: data)
                observer(.success(object))
                observer(.completed)
            } catch {
                observer(.completed)
                return Disposables.create()
            }
            
            return Disposables.create()
        }.subscribe(on: scheduler)
    }
    
    func fetchImage(by path: String) -> Maybe<Image> {
        Maybe.create { observer in
            guard
                let root = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
                let pathUrl = URL(string: path)
            else {
                observer(.completed)
                return Disposables.create()
            }
            
            let newPath = pathUrl.pathComponents.filter { $0 != "/" }.joined(separator: "/")
            
            let url = root
                .appendingPathComponent(newPath)
            
            guard let data = self.fileManager.contents(atPath: url.path) else {
                observer(.completed)
                return Disposables.create()
            }

            guard let image = Image(data: data) else {
                observer(.completed)
                return Disposables.create()
            }

            observer(.success(image))
            return Disposables.create()
        }.subscribe(on: scheduler)
    }
    
    private func createFolders(at url: URL) throws {
        let folderUrl = url.deletingLastPathComponent()
        guard !fileManager.fileExists(atPath: folderUrl.path) else { return }
        try fileManager.createDirectory(
            at: folderUrl,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}
