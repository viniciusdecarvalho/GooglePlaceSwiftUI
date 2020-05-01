//
//  Mocks.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 19/04/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import Foundation
import CoreLocation

class Mocks {
    
    private static var address = [
        "Av. Senador Fernandes Távora, 3290 - Parque Genibaú, Fortaleza - CE, 60534-280, Brasil",
        "Av. Senador Fernandes Távora, 2340 - Jóquei Clube, Fortaleza - CE, 60534-280, Brasil",
        "R. Daniel de Castro, 136 - Autran Nunes, Fortaleza - CE, 60527-160, Brasil",
        "Av. Ministro Albuquerque Lima, 788 - Conj. Ceará I, Fortaleza - CE, 60533-696, Brasil",
        "R. Elesbão Veloso, 139 - Dom Lustosa, Fortaleza - CE, 60000-000, Brasil",
        "Av. Genibaú, 635 - Parque Genibaú, Fortaleza - CE, 60534-230, Brasil",
        "R. Moçambique, 230 - Parque Genibaú, Fortaleza - CE, 60534-010, Brasil",
        "R. Cuiabá, 1823 - Henrique Jorge, Fortaleza - CE, 60510-182, Brasil",
        "R. Martins Neto, 609 - Antônio Bezerra, Fortaleza - CE, 60360-415, Brasil",
        "672, Rua Padre José Arteiro, 530 - Antônio Bezerra, Fortaleza - CE, Brasil",
        "Conj. Ceará, Fortaleza - CE, Brasil",
        "R. Estados Unidos, n° 1411 - Parque das Nacoes, Caucaia - CE, 61642-140, Brasil",
        "R. Júlio Braga, 1950 - Bonsucesso, Fortaleza - CE, 60520-130, Brasil",
        "Av. Senador Fernandes Távora, 590 - Jóquei Clube, Fortaleza - CE, 60510-111, Brasil",
        "Av. Lineu Machado, 1389 - Jóquei Clube, Fortaleza - CE, 60520-101, Brasil",
        "Av. Dom Almeida Lustosa, 2562 - Parque Guadalajara, Caucaia - CE, 61650-000, Brasil",
        "Av. Ministro Albuquerque Lima, 1255 - Conj. Ceará, Fortaleza - CE, 60533-690, Brasil",
        "R. Tampico, 776 - Parque Guadalajara (Jurema), Caucaia - CE, 61650-210, Brasil",
        "Rua Desembargador Felismino, 158 - Autran Nunes, Fortaleza - CE, 60526-760, Brasil",
        "Av. Lineu Machado, 823 - Jóquei Clube, Fortaleza - CE, 60520-102, Brasil"
    ]
    
    private static var names = [
        "Açaí Vitality", "Açaí Com Morango", "Açai Burger Della's", "Puro.Açaí", "Êta Açaí Bom",
        "Point açai", "Açaí Da Lu E Sorveteria","Açai Cristal","Açaí do Gordim Original","PP Lanches & Açai!",
        "Meu Açaí & Lancheteria","Kero Açaí","City Açai","Universo do Açai","Açaí di Origi","Açaiteria Dom Acai",
        "Açai Psicose","Acai Leo - Jurema","I Love Açaí","Lounge Açaí"
    ]
    
    static var position = CLLocationCoordinate2D(latitude: -3.7525225, longitude: -38.60)
    
    static var location = Location(lat: -3.752522400000001, lng: -38.6026676)
    
    static var viewport = Viewport(northeast: location, southwest: location)

    static var geometry = Geometry(location: location, viewport: viewport)

    static var photo = PhotoInfo(height: 665, width: 1000, photo_reference: "CmRaAAAAp4dgBKjPnn9ncSBixAThxNa8BITjJRt756CcrEREKNKhU28n4VU64wmudI6GLQ83XXlmhK_nHuyZj9fkI8-WJfNRwKVZKqn0AhhahiiNQkGl3H7gtogcQCTPsf6nX9mAEhCe9NV_NeCWBIvD34a6RB8nGhReyKNd1LBWzXxXj1-kGh14MmolNw", html_attributions: [""])

    
    static func createResult(_ index: Int) -> Result {
        
//        let indexAddress = Int.random(in: 0 ..< Mocks.address.count)
//
//        let indexNames = Int.random(in: 0 ..< Mocks.names.count)
        
        return Result(formatted_address: Mocks.address[index], geometry: Mocks.geometry, icon: "https://maps.gstatic.com/mapfiles/place_api/icons/shopping-71.png", id: "47258772678536f03126068a7004656ac823a90b", name: Mocks.names[index], opening_hours: nil, photos: [Mocks.photo], place_id: "ChIJL1zB9iFPxwcRqid5ywZnbf0", reference: "ChIJL1zB9iFPxwcRqid5ywZnbf0", types: ["locality", "political"], vicinity: Mocks.address[index], price_level: PriceLevel.init(rawValue: Int.random(in: 0...4)), rating: Double.random(in: 0...5), permanently_closed: nil, user_ratings_total: Int.random(in: 10...50))
    }
    
    static var result = Mocks.createResult(1)

    static var results: Page {
        return Page(status: Page.Status.Ok, results: [
            createResult(0),createResult(1),createResult(2),createResult(3),createResult(4),
            createResult(5),createResult(6),createResult(7),createResult(8),createResult(9),
            createResult(10),createResult(11),createResult(12),createResult(13),createResult(14),
            createResult(15),createResult(16),createResult(17),createResult(18),createResult(19)
        ])
    }
}
