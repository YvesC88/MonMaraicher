//
//  ProductsView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 16/05/2024.
//

import SwiftUI

struct ProductsView: View {

    @State var products: [Products]

    var body: some View {
        List {
            ForEach(products, id: \.id) { product in
                HStack(spacing: 20) {
                    Image(product.name.lowercased())
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(product.name)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
        }
    }
}

#Preview {
    ProductsView(products: [
        .init(id: 1, name: "not found"),
        .init(id: 2, name: "not found"),
        .init(id: 3, name: "fraises"),
        .init(id: 4, name: "cire d'abeille"),
        .init(id: 5, name: "raisin de cuve"),
        .init(id: 6, name: "abricots"),
        .init(id: 7, name: "tomates"),
        .init(id: 8, name: "framboises")
    ])
}
