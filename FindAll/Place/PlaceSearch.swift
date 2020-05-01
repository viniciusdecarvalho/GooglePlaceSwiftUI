//
//  PlaceSearch.swift
//  GoogleMapsApp
//
//  Created by Vinicius Carvalho on 24/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import Foundation

protocol Query {
    
    var baseUrl: String { get }
    
    var searchType: String { get }
    
    var output: String { get }
    
    func withUrl(_ url: String) -> Query
    
    func withSearchType(_ type: String) -> Query
    
    func withOutput(_ output: String) -> Query
    
    func withKey(_ key: String) -> Query
    
    func addParameter(_ value: String?, forKey name: String) -> Query
    
    var url: String { get }
}

protocol SearchModule {
    func createQuery() -> Query
}

protocol Place {
    func of(query: Query, complete: @escaping (Page?, Error?) -> ())
}

enum QueryError: Error {
    case InvalidURL(String)
}

//"https://maps.googleapis.com/maps/api/place/"
class SearchParam: ObservableObject {
    
    var baseUrl: String
    var output: String
    var language: String
    var key: String
    
    init( baseUrl: String, output: String, language: String, key: String) {
        self.baseUrl = baseUrl
        self.output = output
        self.language = language
        self.key = key
    }
}

class GooglePlace: Place {

    private let searchParam: SearchParam
    private let decoder = JSONDecoder()

    init(_ param: SearchParam) {
        self.searchParam = param
    }

    func of(query: Query, complete: @escaping (Page?, Error?) -> ())  {

        let queryUrl = query
                .withUrl(searchParam.baseUrl)
                .withOutput(searchParam.output)
                .addParameter(searchParam.key, forKey: "key")
                .addParameter(searchParam.language, forKey: "language")
                .url
        
        print(queryUrl)
        
        guard let url = URL(string: queryUrl) else {
            complete(nil, QueryError.InvalidURL(queryUrl))
            return
        }
        
        let session: URLSession = .init(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, res, err) in
        
            do {
                if let err = err {
                    complete(nil, err)
                    return
                }
            
                if let content = data {
                    let results = try self.decoder.decode(Page.self, from: content)
                    complete(results, nil)
                    return
                }
                
            } catch {
                complete(nil, error)
            }
        }
        
        task.resume()
    }
}

struct GooglePlaceService {
    public static func get(search: SearchParam) -> Place {
        GooglePlace(search)
    }
}

enum InputType: String {
    case inputtype = "inputtype"
    case phonenumber = "phonenumber"
}

class PlaceQuery: Query {
    
    var baseUrl: String = ""
    var searchType: String = ""
    var output: String = ""
    var parameters: [String : String?] = [:]
    
    init() {
    }
    
    func withUrl(_ url: String) -> Query {
        self.baseUrl = url
        return self
    }
    
    func withSearchType(_ type: String) -> Query {
        self.searchType = type
        return self
    }
    
    func withOutput(_ output: String) -> Query {
        self.output = output
        return self
    }
    
    func withKey(_ key: String) -> Query {
        self.addParameter(key, forKey: "key")
    }
    
    func addParameter(_ value: String?, forKey name: String) -> Query {
        if let val = value {
            self.parameters.updateValue(val, forKey: name)
        }
        
        return self
    }
    
    var url: String {
        
        guard var root = URLComponents(string: "\(baseUrl)/\(searchType)/\(output)") else {
            preconditionFailure("can't create url")
        }
        
        root.queryItems = parameters
                            .filter { param in param.value != nil }
                            .map { param in URLQueryItem(name: param.key, value: param.value) }
        
        guard let url = root.url else {
            preconditionFailure("Can't create url from url components...")
        }
        
        return url.absoluteString
    }
}

struct FindPlaceFromText: SearchModule {
    
    var inputtype: InputType
    var input: String
    
    func createQuery() -> Query {
        PlaceQuery()
            .withSearchType("findplacefromtext")
            .addParameter(inputtype.rawValue, forKey: "inputtype")
            .addParameter(input, forKey: "input")
    }
}

struct NearbySearch: SearchModule {
    var radius: Int
    var location: Location
    var keyword: String?
    var minprice: Double?
    var maxprice: Double?
    var name: String?
    var opennow: Bool?
    var type: String?
    var pagetoken: String?
    
    init(radius: Int, location: Location, pagetoken: String?) {
        self.radius = radius
        self.location = location
        self.pagetoken = pagetoken
    }
    
    func createQuery() -> Query {
        return PlaceQuery()
            .withSearchType("nearbysearch")
            .addParameter(radius.description, forKey: "radius")
            .addParameter(location.description, forKey: "location")
            .addParameter(keyword, forKey: "keyword")
            .addParameter(minprice?.description, forKey: "minprice")
            .addParameter(maxprice?.description, forKey: "maxprice")
            .addParameter(name, forKey: "name")
            .addParameter(opennow?.description.lowercased(), forKey: "opennow")
            .addParameter(type, forKey: "type")
            .addParameter(pagetoken, forKey: "pagetoken")
    }
}

struct TextSearch: SearchModule {
    var query: String
    var region: Int?
    var location: Location?
    var radius: Int?
    var minprice: Double?
    var maxprice: Double?
    var opennow: Bool?
    var type: String?
    var pagetoken: String?
    
    func createQuery() -> Query {
        return PlaceQuery()
            .withSearchType("textsearch")
            .addParameter(query, forKey: "query")
            .addParameter(region?.description, forKey: "region")
            .addParameter(location?.description, forKey: "location")
            .addParameter(radius?.description, forKey: "radius")
            .addParameter(minprice?.description, forKey: "minprice")
            .addParameter(maxprice?.description, forKey: "maxprice")
            .addParameter(opennow?.description.lowercased(), forKey: "opennow")
            .addParameter(type, forKey: "type")
            .addParameter(pagetoken, forKey: "pagetoken")
    }
}
