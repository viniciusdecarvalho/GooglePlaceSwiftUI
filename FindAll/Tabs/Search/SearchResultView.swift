//
//  SearchResultView.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 19/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI
import CoreLocation
//import MapKit

struct SearchResultView: View {
    
//    private let formatter: () = MKDistanceFormatter().unitStyle = .full
    
    var result: Result
    var position: CLLocationCoordinate2D
    
    var image: String { return result.icon }
    var name: String { return result.name }
    var address: String { return result.address }
    var rating: Double? { return result.rating }
    var distance: Double { return result.distance(of: position) / 1000 }
    
    var body: some View {
        HStack {
            Image(systemName: "person.2")
                .padding(.all)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack {
                    if rating != nil {
                        Text(String(format: "%.2f", rating!))
                            .font(.caption)
                            .fontWeight(.regular)
                            .foregroundColor(.secondary)
                                                    
                        Image(systemName: "star.circle.fill")
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.2f km", distance))
//                    Text(self.formatter.string(fromDistance: distance))
                        .font(.caption)
                        .underline()
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                }
                
                
            }
//
//            VStack(alignment: .trailing) {
//
//                HStack {
//                    if rating != nil {
//                        Text(String(format: "%.2f", rating!))
//                            .font(.caption)
//                            .fontWeight(.regular)
//                            .foregroundColor(.secondary)
//
//                        Image(systemName: "star.circle.fill")
//                            .foregroundColor(.gray)
//                    }
//                }
//
//                Text(String(format: "%.2f KM", distance))
//                    .font(.caption)
//                    .underline()
//                    .foregroundColor(.primary)
//            }
        }
//        .padding(.lea)
    }
}

#if DEBUG
struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(result: Mocks.result, position: Mocks.position)
            .previewLayout(.sizeThatFits)
    }
}
#endif
