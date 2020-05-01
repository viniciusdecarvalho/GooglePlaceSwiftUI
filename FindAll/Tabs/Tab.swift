//
//  Tab.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 28/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI

struct Tab<Content: View>: View {
    var image: String
    var name: String
    let content: Content
    
    @State private var background: Color = Color.clear
    @State private var foreground: Color = Color.blue
    
    @inlinable public init(
        image: String,
        name: String,
        @ViewBuilder content: () -> Content
    )
    {
        self.image = image
        self.name = name
        self.content = content()
    }
    
    var body: some View {
        self.content
        .tabItem {
            VStack {
                Image(systemName: self.image)
                    .foregroundColor(self.foreground)
                    .background(self.background)
                
                Text(self.name)
            }
        }
        .onAppear(perform: {
            self.foreground = Color.white
            self.background = Color.blue            
        })
        .onDisappear(perform: {
            self.foreground = Color.blue
            self.background = Color.white
        })
    }
}
