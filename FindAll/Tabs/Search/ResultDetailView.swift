//
//  ResultDetailView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 20/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI
import MapKit
import Combine

struct ResultDetailView: View {
    
    let result: Result
    
    @State private var selectedSection = 0
    @State private var isFavorite = false
    
    init(result: Result) {
        self.result = result
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Image(systemName: "person.3")
                .font(.title)
                .foregroundColor(.black)
                .overlay(Circle()
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: 200, height: 200, alignment: .center)
                )
                .offset(y: -80)
            
            Text(result.name)
                .font(.title)
                .foregroundColor(.black)

            Text(result.address)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            VStack {
                Picker("", selection: self.$selectedSection) {
                    Text("Detail").tag(0)
                    Text("Photos").tag(1)
                    Text("Location").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            ZStack {
                if self.selectedSection == 0 {
                    DetailSegment(result: self.result)
                }
                if self.selectedSection == 1 {
                    PhotosSegment(result: self.result)
                }
                if self.selectedSection == 2 {
                    LocationSegment(result: self.result)
                }
            }
            .frame(height: 250, alignment: .center)
        }
        .multilineTextAlignment(.center)
        .navigationBarTitle(Text(self.result.name), displayMode: .inline)
        .navigationBarItems(trailing:
            Toggle(isOn: self.$isFavorite) {
                Image(systemName: self.isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .frame(width: 48, height: 48)
            }
        )
    }
}

protocol Segment: View, Identifiable {
    var name: String { get }
}

extension Segment {
    var id: String {
        return UUID().uuidString
    }
}

struct DetailSegment: Segment {
    var name: String = "Detail"
    var result: Result
    
    var body: some View {
        VStack {
            Text(result.name)
            Text(result.opening_hours.debugDescription)
            Text(result.rating.debugDescription)
            Text(result.user_ratings_total.debugDescription)
            Text(result.types.debugDescription)
        }
    }
}

struct PhotosSegment: Segment {
    var name: String = "Photos"
    var result: Result
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(self.result.photos ?? []) { photo in
                        Text(photo.photo_reference)
                    }
                }
            }
        }
    }
}

class MapManager: NSObject, MKMapViewDelegate, ObservableObject {
    
    @Published var destiny: CLLocationCoordinate2D = .init()
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }

        let identifier = "Placemark"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            annotationView?.image = UIImage(systemName: "location")
            
//            let smallSquare = CGSize(width: 30, height: 30)
//            let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
//            button.setBackgroundImage(UIImage(systemName: "car.fill"), for: .normal)
//            button.addTarget(self, action: #selector(route), for: .touchUpInside)
//            annotationView?.leftCalloutAccessoryView = button
            
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let placemark = view.annotation as? MKPointAnnotation else { return }
        
        self.destiny = placemark.coordinate
    }
    
    @objc func route() {
        print("\(#function)")
    }
}

struct LocationSegment: Segment {
    
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var shared: Shared
    @ObservedObject var mapManager: MapManager = MapManager()
    
    var name: String = "Location"
    var result: Result
    
    var mark: MKAnnotation {
        
        let pin = MKPointAnnotation(__coordinate: result.geometry.position, title: result.name, subtitle: "Route")
        
        return pin
    }
    
    var routeView: RouteView {
        RouteView(origin: self.locationManager.location!.coordinate, destiny: self.result.geometry.position)
    }
    
    var body: some View {
        
        ZStack {
            Map(delegate: self.mapManager)
                .annotation(self.mark)
                .staticRegion(result.geometry.position, span: 0.01)
                .enableZoom(false)
                .enableScroll(false)
            
            VStack {
                Spacer()
                HStack {
                    if self.locationManager.location != nil {
                        NavigationLink(destination: self.routeView) {
                            VStack {
                                ZStack {
                                    Image(systemName: "car.fill")
                                        .frame(width: 32, height: 32)
                                    Circle()
                                        .frame(width: 64, height: 64, alignment: .center)
                                        .foregroundColor(.blue)
                                        .opacity(0.3)
                                }
                                Text("Driving")
                            }
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    if self.shared.canOpenGoogleMaps {
                        Button(action: {
                            self.shared.openGoogleMaps(destiny: self.result.geometry.position)
                        }) {
                            Image("googlemaps")
                                .resizable()
                                .frame(width: 48, height: 48, alignment: .center)
                            Text("Google Maps")
                        }
                    }
                    
                    if self.shared.canOpenWaze {
                        Button(action: {
                            self.shared.openWaze(destiny: self.result.geometry.position)
                        }) {
                            Image("waze")
                                .resizable()
                                .frame(width: 48, height: 48, alignment: .center)
                            Text("Waze")
                        }
                    }
                                    
                    Button(action: {
                        self.shared.openMaps(destiny: self.result.geometry.position)
                    }) {
                        Image("maps")
                            .resizable()
                            .frame(width: 48, height: 48, alignment: .center)
                        Text("Maps")
                    }
                }
            }
        }
    }
}

struct ResultDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ResultDetailView(result: Mocks.result)
//            .previewLayout(.sizeThatFits)
    }
}
