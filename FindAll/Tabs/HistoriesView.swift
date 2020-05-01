//
//  HistoriesView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 05/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI

struct HistoriesView: View, Identifiable {
    
    var id: String = UUID().uuidString
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Tab(image: "gobackward", name: "History") {
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
    }
}
