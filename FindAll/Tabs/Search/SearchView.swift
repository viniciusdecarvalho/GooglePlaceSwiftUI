//
//  SearchView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI
import CoreLocation
import os

struct SearchView: View, Identifiable, SearchBarDelegate {
    
    var id: String = UUID().uuidString
    
    @EnvironmentObject var settings: Settings
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var queryManager: TextQueryManager
    
    @State var loading = false
    @State var filter = ""
    
    @State var error: Error? = nil
    @State var hasError = false
    
    var body: some View {
        Tab(image: "magnifyingglass", name: "Find") {
            ZStack {
                VStack {
                    SearchBar(delegate: self)
                    
                    List {
                        
                        ForEach(self.queryManager.results) { result in
                            NavigationLink(destination: ResultDetailView(result: result)) {
                                SearchResultView(result: result, position: self.coordinate)
                            }
                        }
                        if self.queryManager.nextPageToken != nil {
                            Button(action: {
                                self.searchBy(text: self.filter, token: self.queryManager.nextPageToken)
                            }) {
                                Text("More...")
                            }
                        }
                    }
                    .disabled(self.queryManager.quering)
                }
                
                ActivityIndicator(isAnimating: self.queryManager.quering, style: .large)
            }
        }
        .alert(isPresented: self.$hasError) {
            Alert(title: Text("Sorry, any error!"), message: Text(self.error?.localizedDescription ?? "Unknown error!"), dismissButton: .default(Text("OK")))
        }
        .onAppear(perform: {
            self.queryManager.onError { err in
                self.error = err
                self.hasError = true
            }
        })
    }
    
    func searchBarSearch(text: String) {
        self.searchBy(text: text)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return self.locationManager.location?.coordinate ?? .init(latitude: 0, longitude: 0)
    }
    
    func searchBy(text: String, token: String? = nil) {
        print("\(#function)")
        let location = self.coordinate
        let lat = location.latitude
        let lng = location.longitude
        
        let params = self.settings.placeParams
        
        self.queryManager.request(search: params, text: text, location: .init(lat: lat, lng: lng), radius: 500, pagetoken: token)
    }
}

protocol SearchBarDelegate {
    func searchBarSearch(text: String)
}

struct SearchBar: UIViewRepresentable {
    
    var delegate: SearchBarDelegate?
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Get here"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        let searchBar: SearchBar
        var text: String = ""
        
        init(_ searchBar: SearchBar) {
            self.searchBar = searchBar
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
            print("\(#function) - \(searchText)")
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print("\(#function) - \(text)")
            self.searchBar.delegate?.searchBarSearch(text: self.text)
            searchBar.endEditing(true)
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            print("\(#function)")
            self.searchBar.delegate?.searchBarSearch(text: self.text)
            searchBar.endEditing(true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            print("\(#function)")
            self.searchBar.delegate?.searchBarSearch(text: self.text)
            
            searchBar.endEditing(true)
        }
    }
    
//    var delegate: SearchBarDelegate
//    @State private var filter: String
//
//    init(
//        delegate: SearchBarDelegate
//    ) {
//        self.delegate = delegate
//    }
//
//    var body: some View {
//        HStack {
//            TextField("Busque aqui...", text: self.$filter, onCommit: {
//                self.delegate.onDidSearchSelected(filter: self.filter)
//            })
//
//            Button(action: {
//                self.delegate.onDidSearchSelected(filter: self.filter)
//            }) {
//                Image(systemName: "magnifyingglass.circle")
//            }
//            .disabled(self.filter.isEmpty)
//        }
//        .padding()
//    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        
        return SearchView()
            .environmentObject(Settings())
            .environmentObject(TextQueryManager(page: Mocks.results))
            .environmentObject(LocationManager())
    }
}
