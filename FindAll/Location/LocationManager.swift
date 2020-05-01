//
//  LocationManager.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

@available(iOS 13.0, *)
class LocationManager: NSObject, ObservableObject {

//    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    
    @Published var permission: Bool = false
    @Published var status: CLAuthorizationStatus?
    @Published var location: CLLocation?

    override init() {
        super.init()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.showsBackgroundLocationIndicator = true
        self.locationManager.startUpdatingLocation()
    }
    
    func requestLocation() -> Void {
        self.locationManager.requestLocation()
    }
    
    var authorized: Bool {
        if CLLocationManager.locationServicesEnabled() {
            if let status = self.status {
                return status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways
            }
        }
        return false
    }
}

@available(iOS 13.0, *)
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        self.permission = self.authorized
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.locationManager.stopUpdatingLocation()
        self.location = location
        print("\(#function) - location: \(location.latitude), \(location.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension CLLocation {
    var latitude: Double {
        return self.coordinate.latitude
    }
    
    var longitude: Double {
        return self.coordinate.longitude
    }
}


