//
//  FarmerDetailsView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 27/02/2024.
//

import SwiftUI
import MapKit

struct FarmerDetailsView: View {

    private let viewModel: FarmerDetailsViewModel

    init(viewModel: FarmerDetailsViewModel) {
        self.viewModel = viewModel
    }

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                titleSection
                Divider()
                imageSection
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                    descriptionSection
                    linkSection
                    Divider()
                    mapSection
                    addressSection
                }
                .padding()
            }
        }
        .overlay(closeButton, alignment: .topTrailing)
    }
}

private extension FarmerDetailsView {

    private var imageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.farmerImages, id: \.self) { farmerImage in
                    AsyncImage(url: URL(string: farmerImage)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFill()
                    .frame(width: 180, height: 230)
                    .clipShape(.rect(cornerRadius: 16))
                }
            }
            .padding(8)
        }
        .shadow(radius: 8)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.title)
                .font(.largeTitle)
                .bold()
            Text(viewModel.city)
                .foregroundStyle(.secondary)
        }
        .padding(20)
        .padding(.trailing)
    }

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("""
Bienvenue à la ferme de William, où la nature prospère en harmonie. William cultive une grande variété de fruits et légumes avec amour et respect pour l'environnement.\nSans pesticides ni produits chimiques synthétiques, sa ferme est un havre de biodiversité où les méthodes agricoles durables préservent la terre pour les générations futures.
""")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private var linkSection: some View {
        HStack {
            if let url = URL(string: "https://www.google.fr") {
                Link("Obtenir plus d'informations", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
        }
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.subheadline)
                .padding(8)
                .background(.thinMaterial)
                .clipShape(.circle)
                .shadow(radius: 10)
                .padding()
        }
    }

    private var mapSection: some View {
        Map(position: .constant(.automatic), bounds: .init(minimumDistance: 1000)) {
            Marker(viewModel.title, systemImage: viewModel.markerSystemImageName, coordinate: viewModel.coordinate)
                .tint(.orange)
        }
        .aspectRatio(1.5, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(radius: 2)
        .allowsHitTesting(false)
        .mapControlVisibility(.hidden)
    }

    private var directionButton: some View {
        Button {
            viewModel.onItineraryButtonTapped()
        } label: {
            Text(viewModel.directionButtonTitle)
        }
        .font(.headline)
    }

    private var addressSection: some View {
        HStack {
            Text(viewModel.address)
                .font(.callout)
                .padding()
            Spacer()
            directionButton
                .frame(width: 80, height: 35)
                .background()
                .clipShape(.capsule)
                .padding()
        }
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    FarmerDetailsView(viewModel: FarmerDetailsViewModel(farmer: Farmer(id: 1, name: "chez william", location: .init(latitude: 48.86935, longitude: 2.331314, address: .init(streetNumber: 20, streetName: "rue de la paix", zipCode: 75000, city: "paris")), images: .init(farmer1: "https://plus.unsplash.com/premium_photo-1686529591582-7c53fa833bd9?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", farmer2: "https://images.unsplash.com/photo-1610348725531-843dff563e2c?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", farmer3: "https://images.unsplash.com/photo-1542838132-92c53300491e?q=80&w=3174&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", farmer4: "https://images.unsplash.com/photo-1620706857370-e1b9770e8bb1?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", farmer5: "https://images.unsplash.com/photo-1488459716781-31db52582fe9?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", farmer6: "https://images.unsplash.com/photo-1623227866882-c005c26dfe41?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGZydWl0cyUyMCUyNiUyMGwlQzMlQTlndW1lc3xlbnwwfHwwfHx8MA%3D%3D"))))
}
