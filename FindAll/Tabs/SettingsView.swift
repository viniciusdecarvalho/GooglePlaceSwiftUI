//
//  SettingsView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI

struct SettingsView: View, Identifiable {
    
    var id: String = UUID().uuidString
    
    @EnvironmentObject var settings: Settings
    
    var body: some View {
        Tab(image: "gear", name: "Settings") {
            Text("Setting View")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Text("Hello!!")
        }
    }
}
