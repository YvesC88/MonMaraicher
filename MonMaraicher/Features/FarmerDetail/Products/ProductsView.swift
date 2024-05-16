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
                Text(product.name)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
        }
    }
}

#Preview {
    ProductsView(products: [.init(id: 1, name: "Tomates"), .init(id: 2, name: "Cerises")])
}
