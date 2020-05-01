//
//  ActivityIndicator.swift
//  FindAll
//
//  Created by Vinicius Carvalho on 29/03/20.
//  Copyright © 2020 Vinicius Carvalho. All rights reserved.
//

import SwiftUI

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    var isAnimating: Bool
    
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isAnimating: true, style: .large)
    }
}
