//
//  Map.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 25/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import MapKit
import SwiftUI

struct Map: UIViewRepresentable {
    
    private let mapView: MKMapView = MKMapView(frame: .zero)
    
    init() {
    }
    
    init(delegate: MKMapViewDelegate) {
        self.init()
        self.mapView.delegate = delegate
    }
    
    func makeUIView(context: Context) -> MKMapView {
        return self.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    func showScale(_ show: Bool) -> Map {
        self.mapView.showsScale = show
        return self
    }
    
    func showsTraffic(_ show: Bool) -> Map {
        self.mapView.showsTraffic = show
        return self
    }
    
    func showsType(_ type: MKMapType) -> Map {
        self.mapView.mapType = type
        return self
    }
    
    func enableZoom(_ enable: Bool) -> Map {
        self.mapView.isZoomEnabled = enable
        return self
    }
    
    func enableScroll(_ enable: Bool) -> Map {
        self.mapView.isScrollEnabled = enable
        return self
    }
    
    func showUserLocation(_ show: Bool, title: String = "") -> Map {
        self.mapView.showsUserLocation = show
        self.mapView.userLocation.title = title
        return self
    }
    
    func staticRegion(_ center: CLLocationCoordinate2D, span delta: Double) -> Map {
        let region = MKCoordinateRegion(center: center, span: .init(latitudeDelta: delta, longitudeDelta: delta))
        self.mapView.setRegion(region, animated: true)
        return self
    }
    
    func annotation(_ mark: MKAnnotation) -> Map {
        self.mapView.addAnnotation(mark)
        return self
    }
    
    func annotations(_ marks: [MKAnnotation]) -> Map {
        self.mapView.addAnnotations(marks)
        return self
    }

    func route(origin: CLLocationCoordinate2D, destiny: CLLocationCoordinate2D ) -> Map {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destiny, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { response, error in
            guard let unwrappedResponse = response else { return }

            let route = unwrappedResponse.routes.sorted { (first, second) -> Bool in
                first.expectedTravelTime > second.expectedTravelTime
            }.first!
            
            let stepInfoIndex = route.steps.count / 2
//
//            for route in routes {
//
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                let steps = route.steps.map { (step) -> CLLocationCoordinate2D in step.polyline.coordinate }
                
                self.animate(route: steps, duration: TimeInterval(1), completion: {
                
                    let time = Int(route.expectedTravelTime / 60)
                    
                    let info = InfoAnnotation(position: steps[stepInfoIndex], title: route.name, subtitle: String(format: "%.2f %@", time, time > 1 ? "minutes" : "minute"))
                    
                    self.mapView.addAnnotation(info)
                })
//            }

//            for route in routes {
////                    self.mapView.addOverlay(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect.insetBy(dx: 300, dy: 300), animated: true)
//
//                for step in route.steps {
//                    self.mapView.addOverlay(step.polyline)
////                        self.mapView.setVisibleMapRect(step.polyline.boundingMapRect, animated: true)
//                }
//            }
        }

        let start = PointAnnotation(position: origin, title: "You here!", subtitle: "")
        let end = PointAnnotation(position: destiny, title: "Your destiny!", subtitle: "")

        return self.annotations([start, end])
    }

    @State var polyline: MKPolyline?
    // Somewhere in your View Controller
    @State var drawingTimer: Timer?
    // ....
    func animate(route: [CLLocationCoordinate2D], duration: TimeInterval, completion: (() -> Void)?) {
        guard route.count > 0 else { return }
        var currentStep = 0
        let totalSteps = route.count
        let stepDrawDuration = duration/TimeInterval(totalSteps)
        
        drawingTimer = Timer.scheduledTimer(withTimeInterval: stepDrawDuration, repeats: true) { timer in
      
            guard currentStep < totalSteps else {
                // If this is the last animation step...
                let finalPolyline = MKPolyline(coordinates: route, count: route.count)
                self.mapView.addOverlay(finalPolyline)
                // Assign the final polyline instance to the class property.
                self.polyline = finalPolyline
                timer.invalidate()
                completion?()
                return
            }
            
            // Animation step.
            // The current segment to draw consists of a coordinate array from 0 to the 'currentStep' taken from the route.
            let subCoordinates = Array(route.prefix(upTo: currentStep))
            let currentSegment = MKPolyline(coordinates: subCoordinates, count: subCoordinates.count)
            self.mapView.addOverlay(currentSegment)
            
            currentStep += 1
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var map: Map
        
        init(_ parent: Map) {
            self.map = parent
        }
    }
}
