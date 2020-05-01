//
//  ResultsExtensions.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 19/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

extension Result {
    
    func distance(of location: CLLocationCoordinate2D) -> Double {
        let origin = CLLocation(latitude: self.geometry.location.lat, longitude: self.geometry.location.lng)
        let destiny = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let distance = origin.distance(from: destiny)
        return distance
    }
}

extension Page: Identifiable {
    
    var id: String {
        return UUID().uuidString
    }
}

extension PhotoInfo: Identifiable {
    
    var id: String {
        return UUID().uuidString
    }
}

extension Geometry {
    var position: CLLocationCoordinate2D {
        .init(latitude: self.location.lat, longitude: self.location.lng)
    }
}
