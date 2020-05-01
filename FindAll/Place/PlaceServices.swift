//
//  PlaceServices.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 04/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import MapKit

//class NearbyParams {
//    var radius: Int
//    var position: CLLocationCoordinate2D
//    var token: String?
//    
//    init(radius: Int, position: CLLocationCoordinate2D) {
//        self.radius = radius
//        self.position = position
//    }
//}
//
//class PlaceServices {
//    
//    private var search: SearchParam
//    
//    init(_ search: SearchParam) {
//        self.search = search
//    }
//    
//    func nearby(_ params: NearbyParams, onComplete: @escaping (Results?, Error?) -> Void) {
//        
//        let place = GooglePlaceService.get(search: self.search)
//        
//        let position = params.position
//        let radius = params.radius
//        let token = params.token
//
//        let nearby = NearbySearch(radius: radius, location: .init(lat: position.latitude, lng: position.longitude), pagetoken: token)
//
//        let query = nearby.createQuery()
//
//        place.of(query: query, complete: onComplete)
//    }
//}

class NearbyQueryManager: ObservableObject {
    
    @Published var results = [Page]()
    
    var search: SearchParam
    
    init(_ search: SearchParam) {
        self.search = search
    }
    
    func request(location: Location, radius: Int, pagetoken: String?) {
        let place = GooglePlaceService.get(search: self.search)
        
        let module = NearbySearch(radius: radius, location: location, pagetoken: pagetoken)
        
        let query = module.createQuery()
        
        place.of(query: query, complete: { results, error in
            if let err = error {
                self.onError(err)
                return
            }
            
            if pagetoken != nil {
                self.results.append(results ?? Page.empty)
            } else {
                self.results = [Page.empty]
            }
            
            self.onSuccess(results ?? Page.empty)
        })
    }
    
    var onError: (Error) -> Void = { _ in }
    
    func onError(_ error: @escaping (Error) -> ()) {
        self.onError = error
    }
    
    var onSuccess: (Page) -> Void = { _ in }
    
    func onSuccess(_ success: @escaping (Page) -> ()) {
        self.onSuccess = success
    }
}

class TextQueryManager: ObservableObject {
    
    @Published var page = [Page]()
    @Published var nextPageToken: String? = nil
    @Published var results = [Result]()
    @Published var quering = false
    
    init() {
        self.onError { err in
            self.quering = false
            print(err)
        }
        self.onSuccess {_ in
            self.quering = false
        }
    }
    
    convenience init(page: Page) {
        self.init()
        
        self.page = [page]
        self.results = page.results
    }
    
    func request(search: SearchParam, text: String, location: Location, radius: Int, pagetoken: String?) {
        print("\(#function)")
        let place = GooglePlaceService.get(search: search)
        
        let module = TextSearch(query: text, region: nil, location: location, radius: radius, minprice: nil, maxprice: nil, opennow: nil, type: nil, pagetoken: pagetoken)
        
        let query = module.createQuery()
        
        self.quering = true
        
        self.page = [Page.empty]
        
        place.of(query: query, complete: { page, error in
            
            DispatchQueue.main.async {
            
                if let err = error {
                    self.onError.forEach{ fn in fn(err) }
                    return
                }
            
                if pagetoken != nil {
                    self.page.append(page ?? Page.empty)
                } else {
                    self.page = [page ?? Page.empty]
                }
                
                self.nextPageToken = self.page.last?.next_page_token
                self.results = self.page.flatMap { (r) in r.results }
                
                self.onSuccess.forEach{ fn in fn(page ?? Page.empty) }
            }
        })
    }
    
    var onError: [(Error) -> Void] = []
    
    func onError(_ error: @escaping (Error) -> ()) {
        self.onError.append(error)
    }
    
    var onSuccess: [(Page) -> Void] = []
    
    func onSuccess(_ success: @escaping (Page) -> ()) {
        self.onSuccess.append(success)
    }
}
