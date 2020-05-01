//
//  PointAnnotation.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 26/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class PointAnnotation: MKPointAnnotation {
    
    init(position: CLLocationCoordinate2D, title: String, subtitle: String) {
        super.init()
        super.coordinate = position
        super.title = title
        super.subtitle = subtitle
    }
}

class InfoAnnotation: PointAnnotation {
    
}
