//
//  Results.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 05/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation

struct Page: Codable {
    
    static var empty = Page(status: Status.ZeroResults, results: [])
    
    var status: Status
    var results: [Result]
    var html_attributions: [String]?
    var next_page_token: String? = nil
    
    enum Status: String, Codable {
        case Ok = "OK"
        case ZeroResults = "ZERO_RESULTS"
        case OverQueryLimit = "OVER_QUERY_LIMIT"
        case RequestDenied = "REQUEST_DENIED"
        case InvalidRequest = "INVALID_REQUEST"
        case UnknownError = "UNKNOWN_ERROR"
    }
}

struct Result: Codable, Identifiable {
    
    var formatted_address: String?
    var geometry: Geometry
    var icon: String
    var id: String
    var name: String
    var opening_hours: OpenHourInfo?
    var photos: [PhotoInfo]?
    var place_id: String
    var reference: String
    var types: [String]
    var vicinity: String?
    var price_level: PriceLevel?
    var rating: Double?
    var permanently_closed: Bool?
    var user_ratings_total: Int?
    
    var address: String {
        return self.formatted_address ?? self.vicinity ?? ""
    }
}

enum PriceLevel: Int, Codable {
    case Free = 0
    case Inexpensive = 1
    case Moderate = 2
    case Expensive = 3
    case VeryExpensive = 4
}

struct Location: Codable, CustomStringConvertible {
    var lat: Double
    var lng: Double

    var description: String { "\(lat),\(lng)" }
}

struct Viewport: Codable {
    var northeast: Location
    var southwest: Location
}

struct Geometry: Codable {
    var location: Location
    var viewport: Viewport
}

struct OpenHourInfo: Codable {
    var open_now: Bool?
}

struct PhotoInfo: Codable {
    var height: Double
    var width: Double
    var photo_reference: String
    var html_attributions: [String]
}
