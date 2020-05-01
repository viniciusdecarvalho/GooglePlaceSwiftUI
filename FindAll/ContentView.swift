//
//  ContentView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI
import CoreLocation

struct ContentView: View {

    private let tabs: [ContentTab] = [
        ContentTab(name: "Favorities", view: AnyView(FavoriteView())),
        ContentTab(name: "Search", view: AnyView(SearchView())),
        ContentTab(name: "Settings", view: AnyView(SettingsView()))
    ]
    
    @State private var selection = 1
    @State private var title = ""
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ForEach(0 ..< self.tabs.count) { index in
                    self.tabs[index]
                        .tag(index)
                        .onAppear(perform: {
                            self.title = self.tabs[index].name
                        })
                }
            }
            .accentColor(Color.blue)
            .navigationBarTitle(Text(self.title), displayMode: .inline)
            .edgesIgnoringSafeArea(.top)
            .onAppear(perform: {
//                UITabBar.appearance().backgroundColor = .black
            })
        }
    }
}

struct ContentTab: View {
    var name: String
    var view: AnyView
    
    var body: some View {
        return view
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Settings())
            .environmentObject(TextQueryManager(page: Mocks.results))
            .environmentObject(LocationManager())
    }
}
