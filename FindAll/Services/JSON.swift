//
//  Request.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 05/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation

class JSON<T: Codable> {
    
    private var callback: Callback<T> = .init()
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func onSuccess(_ onSuccess: @escaping Callback<T>.OnSuccess) -> JSON<T> {
        self.callback.onSuccess(onSuccess)
        return self
    }
    
    func onError(_ onError: @escaping Callback<T>.OnError) -> JSON<T> {
        self.callback.onError(onError)
        return self
    }
    
    func call(url: URLRequest) -> Void {
        let task = self.session.dataTask(with: url) { (data, res, err) in
        
            do {
                if let err = err {
                    self.callback.complete(result: nil, error: err)
                    return
                }
            
                if let content = data {
                    let results = try self.decoder.decode(T.self, from: content)
                    self.callback.complete(result: results, error: nil)
                    return
                }
                
            } catch {
                self.callback.complete(result: nil, error: error)
            }
        }
        
        task.resume()
    }
}

func noop() {}

func noop<T>(value: T) {}

func noop<T>() -> T? { return nil }

func noop<T, S>(value: T) -> S? { return nil }

class Callback<T> {

    typealias OnError = (Error) -> Void
    typealias OnSuccess = (T) -> Void
    typealias OnComplete = (T?, Error?) -> Void

    private var onSuccess: OnSuccess? = noop()
    private var onError: OnError? = noop()
    private var onComplete: OnComplete? = noop()

    func onSuccess(_ onSuccess: @escaping OnSuccess){
        self.onSuccess = onSuccess
    }

    func onError(_ onError: @escaping OnError){
        self.onError = onError
    }

    private func success(_ result: T) {
        guard let onSuccess = self.onSuccess else { return }
        onSuccess(result)
    }

    private func error(_ error: Error) {
        guard let onError = self.onError else { return }
        onError(error)
    }

    func complete(result: T?, error: Error?) {
        if let err = error {
            self.error(err)
        }

        if let res = result {
            self.success(res)
        }

        if let onComplete = self.onComplete {
            onComplete(result, error)
        }
    }
}
