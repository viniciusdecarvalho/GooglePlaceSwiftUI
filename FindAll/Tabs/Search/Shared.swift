//
//  Shared.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 26/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit

class Shared: ObservableObject {
    
    lazy var canOpenGoogleMaps: Bool = {
        guard let url = URL(string: "comgooglemaps://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }()
    
    func openGoogleMaps(destiny place: CLLocationCoordinate2D) -> Void {
        guard let url = URL(string: "comgooglemaps://?saddr=&daddr=\(place.latitude),\(place.longitude)&directionsmode=driving") else { return }
        return UIApplication.shared.open(url)
    }
    
    lazy var canOpenWaze: Bool = {
        guard let url = URL(string: "waze://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }()
    
    func openWaze(destiny location: CLLocationCoordinate2D) -> Void {
        guard let url = URL(string: "waze://?ll=\(location.latitude),\(location.longitude)&navigate=yes") else { return }
        return UIApplication.shared.open(url)
    }
    
    func openMaps(destiny: CLLocationCoordinate2D) {
        let placemark : MKPlacemark = MKPlacemark(coordinate: destiny, addressDictionary:nil)
        
        let mapItem: MKMapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "Destiny"
        
        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
        
        let currentLocationMapItem: MKMapItem = MKMapItem.forCurrentLocation()
        
        MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: (launchOptions as! [String : Any]))
    }
}
