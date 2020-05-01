//
//  MapContentView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

//
//  MapaView.swift
//  SmartCar
//
//  Created by Vinicius Carvalho on 24/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import MapKit
import SwiftUI

extension MKMapView {

    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }

    func radius() -> Int {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return Int(centerLocation.distance(from: topCenterLocation))
    }
}

private class MapEventsDelegate {
    
    private var onChangeRegionViewHandler: [(MapView, CLLocationCoordinate2D, Int) -> Void] = []
    private var onUpdateMapViewHandler: [(MapView, CLLocationCoordinate2D, Int) -> Void] = []
    
    func onChangeRegionView(complete: @escaping (MapView, CLLocationCoordinate2D, Int) -> Void) {
        self.onChangeRegionViewHandler.append(complete)
    }
    
    func onUpdateMapView(complete: @escaping (MapView, CLLocationCoordinate2D, Int) -> Void) {
        self.onUpdateMapViewHandler.append(complete)
    }
    
    func raiseChangeRegionView(uiView: MapView, coordinate: CLLocationCoordinate2D, radius: Int) {
        self.onChangeRegionViewHandler.forEach { handler in
            handler(uiView, coordinate, radius)
        }
    }
    
    func raiseUpdateMapView(uiView: MapView, coordinate: CLLocationCoordinate2D, radius: Int) {
        self.onUpdateMapViewHandler.forEach { handler in
            handler(uiView, coordinate, radius)
        }
    }
    
}

struct MapView: UIViewRepresentable {
    
    private let mapView: MKMapView = MKMapView(frame: .zero)
    private let events = MapEventsDelegate()
    
    @Binding var userPosition: CLLocationCoordinate2D
    @Binding var centerPosition: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        self.mapView.delegate = context.coordinator
        self.mapView.showsScale = true
        self.mapView.showsTraffic = true
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
//        self.mapView.showsUserLocation = true
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 3000)
        self.mapView.setCameraZoomRange(zoomRange, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate.latitude = self.centerPosition.latitude
        pin.coordinate.longitude = self.centerPosition.longitude        
        self.addAnnotation(pin)
        
        return self.mapView
    }
    
    func removeAnnotation(_ annotations: [MKAnnotation]) -> Void {
        self.mapView.removeAnnotations(annotations)
    }
    
    func removeAllAnnotation() -> Void {
        self.removeAnnotation(self.mapView.annotations)
    }
    
    func removeAnnotationsNotVisible(_ radius: Double) -> Void {
//        let circle = CLCircularRegion(center: self.centerPosition, radius: radius, identifier: "center")
//
//        circle.contains(an.coordinate)
//
//        self.mapView.annotations.removeAll { an in
//            return !circle.contains(an.coordinate)
//        }
    }
    
    func addAnnotations(_ annotations: [MKAnnotation]) -> Void {
        self.mapView.addAnnotations(annotations)
    }
    
    func addAnnotation(_ annotation: MKAnnotation) -> Void {
        self.mapView.addAnnotation(annotation)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.removeAnnotations(uiView.annotations)
//        let news = uiView.annotations.filter({ an in
//            return !uiView.annotations.contains { mapAnnotation in
//                return mapAnnotation.coordinate.latitude == an.coordinate.latitude && mapAnnotation.coordinate.longitude == an.coordinate.longitude
//            }
//        })
//        
//        uiView.addAnnotations(news)
        
//        let radius = Double(self.mapView.radius())
//
//        let circle = CLCircularRegion(center: self.centerPosition, radius: radius, identifier: "center")
//
//        let annotations = self.mapView.annotations.filter { an in
//            return !circle.contains(an.coordinate)
//        }
//
//        self.mapView.removeAnnotations(annotations)
//
//        print(self.mapView.annotations.count)
        
        self.events.raiseUpdateMapView(uiView: self, coordinate: self.mapView.centerCoordinate, radius: mapView.radius())
    }
    
    func setRegion(to position: CLLocationCoordinate2D, zoom span: MKCoordinateSpan) {
        let region = MKCoordinateRegion(center: position, span: span)
        self.mapView.setRegion(region, animated: true)
    }

    func onChangeRegionView(complete: @escaping (MapView, CLLocationCoordinate2D, Int) -> Void) -> MapView {
        self.events.onChangeRegionView(complete: complete)
        return self
    }
    
    func onUpdateMapView(complete: @escaping (MapView, CLLocationCoordinate2D, Int) -> Void) -> MapView {
        self.events.onUpdateMapView(complete: complete)
        return self
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var map: MapView
        
        init(_ parent: MapView) {
            self.map = parent
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.map.userPosition = userLocation.coordinate
            self.map.centerPosition = userLocation.coordinate
            
            self.map.setRegion(to: userLocation.coordinate, zoom: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            map.centerPosition = mapView.centerCoordinate
            
            let radius = mapView.radius()
            
            map.events.raiseChangeRegionView(uiView: self.map, coordinate: map.centerPosition, radius: radius)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
//            guard !annotation.isKind(of: MKUserLocation.self) else {
//                return nil
//            }
//
//            let identifier = "Placemark"
//
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//
//            if annotationView == nil {
//                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = true
//                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//                annotationView?.image = UIImage(systemName: "clock")
//            } else {
//                annotationView?.annotation = annotation
//            }
//
//            return annotationView
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let coordinates = view.annotation?.coordinate else { return }
            let span = mapView.region.span
            let region = MKCoordinateRegion(center: coordinates, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        
    }
}

extension MapView {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "Fortaleza - CE"
        annotation.subtitle = "Postos"
        annotation.coordinate = CLLocationCoordinate2D(latitude: -3.75607, longitude: -38.59693)
        return annotation
    }
}
