//
//  RouteView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 26/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

struct RouteView: View {
    
    @EnvironmentObject var shared: Shared
    
    var router = RouterDelegate()
    
    var origin: CLLocationCoordinate2D
    var destiny: CLLocationCoordinate2D
    
    fileprivate func openMaps() {
        let placemark : MKPlacemark = MKPlacemark(coordinate: self.destiny, addressDictionary:nil)
        
        let mapItem:MKMapItem = MKMapItem(placemark: placemark)
        
        mapItem.name = "Destiny"
        
        let launchOptions:NSDictionary = NSDictionary(object: MKLaunchOptionsDirectionsModeDriving, forKey: MKLaunchOptionsDirectionsModeKey as NSCopying)
        
        let currentLocationMapItem: MKMapItem = MKMapItem.forCurrentLocation()
        
        MKMapItem.openMaps(with: [currentLocationMapItem, mapItem], launchOptions: (launchOptions as! [String : Any]))
    }
    
    var body: some View {
        ZStack {
            Map(delegate: self.router)
                .staticRegion(self.origin, span: 0.01)
                .route(origin: self.origin, destiny: self.destiny)
                .edgesIgnoringSafeArea(.top)
    //            .onAppear(perform: {
    //                self.router.route(origin: self.origin, destiny: self.destiny)
    //            })
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Button(action: {
                        self.shared.openGoogleMaps(destiny: self.destiny)
                    }) {
                        ZStack {
                            Image("googlemaps")
                                .resizable()
                                .frame(width: 48, height: 48, alignment: .center)
                        }
                    }
                    
                    Button(action: {
                        self.shared.openWaze(destiny: self.destiny)
                    }) {
                        ZStack {
                            Image("waze")
                                .resizable()
                            .frame(width: 48, height: 48, alignment: .center)
                        }
                    }
                                    
                    Button(action: {
                        self.openMaps()
                    }) {
                        ZStack {
                            Image("maps")
                                .resizable()
                                .frame(width: 48, height: 48, alignment: .center)
                        }
                    }
                }
            }
        }
    }
}

class RouterDelegate: NSObject, MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // Make sure we are rendering a polyline.
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
    
        // Create a specialized polyline renderer and set the polyline properties.
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .black
        polylineRenderer.lineWidth = 4
        polylineRenderer.lineCap = .butt
        polylineRenderer.lineJoin = .bevel
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let info = annotation as? InfoAnnotation {
            let label = UILabel()
            label.adjustsFontSizeToFitWidth = true
            label.backgroundColor = .white
            label.minimumScaleFactor = 0.5
            label.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            label.text = info.subtitle ?? ""
            let view = MKAnnotationView()
            view.addSubview(label)
            return view
        }
        
        return nil
    }
}

struct RouteView_Previews: PreviewProvider {
    static var previews: some View {
//        RouteView(origin: .init(latitude: -3.752522400000001, longitude: -38.6026676), destiny: Mocks.geometry.position)
        VStack {
            Image("googlemaps")
            .resizable()
            .frame(width: 48, height: 48, alignment: .center)
            Image("waze")
            .resizable()
            .frame(width: 48, height: 48, alignment: .center)
            Image("maps")
            .resizable()
            .frame(width: 48, height: 48, alignment: .center)
        }
    }
}
