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
                ForEach(viewModel.imageNames, id: \.self) { imageName in
                    Image(imageName)
                        .resizable()
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
            Marker(viewModel.title, systemImage: viewModel.systemImageName, coordinate: viewModel.coordinate)
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
    FarmerDetailsView(
        viewModel: FarmerDetailsViewModel(
            farmer: FarmerPlace(
                name: "maraîcher bio de grabels",
                location: Location(
                    latitude: 43.65,
                    longitude: 3.9,
                    address: Address(streetNumber: 775, streetName: "avenue du maréchal leclerc", zipCode: 34000, city: "montpellier")
                ),
                imageNames: [
                    "farmer6",
                    "farmer4",
                    "farmer1",
                    "farmer2",
                    "farmer5",
                    "farmer3"
                ]
            )
        )
    )
}
