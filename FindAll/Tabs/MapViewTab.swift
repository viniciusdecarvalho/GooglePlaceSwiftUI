//
//  MapView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI
import MapKit

struct MapViewTab: View, Identifiable {
    
    var id: String = UUID().uuidString
    
    @EnvironmentObject var settings: Settings
    
    @State private var userPosition = CLLocationCoordinate2D(latitude: .zero, longitude: .zero)
    @State private var centerPosition = CLLocationCoordinate2D(latitude: .zero, longitude: .zero)
    @State private var span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    @State private var annotations: [MKAnnotation] = []
    
    @State private var changes = 0
    @State private var radius = 0
    @State private var countUPdates = 0

    fileprivate func createAnnotation(_ result: Result) -> MKAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = result.name
        annotation.subtitle = result.vicinity
        annotation.coordinate = CLLocationCoordinate2D(latitude: result.geometry.location.lat, longitude: result.geometry.location.lng)
        
        return annotation
    }
    
    fileprivate func onChangeRegionView(_ mapView: MapView, _ coord: CLLocationCoordinate2D, _ radius: Int) {
//        let params = NearbyParams(radius: radius, position: coord)
//
//        let service = PlaceServices(SearchParam(
//            baseUrl: self.settings.baseUrl,
//            output: self.settings.output,
//            language: self.settings.language,
//            key: self.settings.key
//        ))
        
//        service.nearby(params, onComplete: { results in
//
//            let annotations = results.results.map(self.createAnnotation)
//            mapView.addAnnotations(annotations)
//            mapView.removeAnnotationsNotVisible(Double(radius))
//
//        }, onError: { err in
//            print(err)
//        })
        self.changes += 1
        //print("\(changes): location: (\(coord.latitude), \(coord.longitude)) - radius: \(radius)")
        self.radius = radius
    }
    
    var body: some View {
        
        return Tab(image: "map", name: "Map") {
            VStack {
                ZStack {
                    MapView(userPosition: self.$userPosition, centerPosition: self.$centerPosition)
                        .onChangeRegionView(complete: self.onChangeRegionView)
                        .edgesIgnoringSafeArea(.all)
                    
                    Circle()
                        .fill(Color.blue)
                        .opacity(0.8)
                        .frame(width: 16, height: 16)
                    
                    VStack {
                        Spacer()
                        HStack {
//                            BackButton(action: {
//
////                                let item: MKMapItem = MKMapItem.forCurrentLocation()
////                                item.openInMaps()
//
//                                let position = CLLocationCoordinate2D(latitude: self.userPosition.latitude, longitude: self.userPosition.longitude)
//
//                                mapView.setRegion(to: position, zoom: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                            })
                            
                            ZStack {
                                Text("\(self.changes)")
                                Circle()
                                    .fill(Color.blue)
                                    .opacity(0.8)
                                    .frame(width: 62, height: 64)
                            }
                            
                            ZStack {
                                Text("\(self.radius)")
                                Circle()
                                    .fill(Color.blue)
                                    .opacity(0.8)
                                    .frame(width: 62, height: 64)
                            }
                            
                            ZStack {
                                Text("\(self.countUPdates)")
                                Circle()
                                    .fill(Color.blue)
                                    .opacity(0.8)
                                    .frame(width: 62, height: 64)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct BackButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button(
            action: {
                self.action()
            },
            label: {
            Image(systemName: "location")
                .frame(width: 48, height: 48)
                .foregroundColor(Color.black)
        })
        .background(Color.blue)
        .opacity(0.3)
        .cornerRadius(38.5)
        .padding()
    }
}
