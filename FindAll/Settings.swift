//
//  Configurations.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 04/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation

class Settings: ObservableObject {    
    @Published var baseUrl = "https://maps.googleapis.com/maps/api/place"
    @Published var output = "json"
    @Published var language = "pt-BR"
    @Published var key = ""
    
    lazy var placeParams: SearchParam = {
        return SearchParam(baseUrl: self.baseUrl, output: self.output, language: self.language, key: self.key)
    }()
}
