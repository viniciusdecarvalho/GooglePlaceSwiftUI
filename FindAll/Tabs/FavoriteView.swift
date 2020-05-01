//
//  FavoriteView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI

struct FavoriteView: View, Identifiable {
    
    var id: String = UUID().uuidString
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Tab(image: "star", name: "Favorites") {
            List {
                Button(action: {}) {
                    Text("Posto Sao Jose")
                }
                
                Button(action: {}) {
                    Text("Pet Shop Fernandes Tavora")
                }
                
                Button(action: {}) {
                    Text("Funeraria ")
                }
            }
        }
        .navigationBarTitle(Text("Favorities"), displayMode: .inline)
    }
}

