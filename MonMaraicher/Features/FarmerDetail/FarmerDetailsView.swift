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
                    .padding()
                Divider()
                imageSection
                    .shadow(radius: 8)
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                    descriptionSection
                    linkSection
                    Divider()
                    mapSection
                        .aspectRatio(1.5, contentMode: .fit)
                        .clipShape(.rect(cornerRadius: 16))
                        .shadow(radius: 2)
                        .allowsHitTesting(false)
                }
                .padding()
            }
        }
        .overlay(closeButton, alignment: .topTrailing)
        .background(.thinMaterial)
    }
}

private extension FarmerDetailsView {

    private var imageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.imageNames, id: \.self) {
                    Image($0)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180)
                        .frame(height: 230)
                        .clipShape(.rect(cornerRadius: 16))
                }
            }
            .padding()
        }
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.title)
                .font(.title)
                .bold()
            Text(viewModel.city)
                .foregroundStyle(.secondary)
        }
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
        Map(position: .constant(.automatic), bounds: .init(minimumDistance: 300)) {
            Marker(viewModel.title, systemImage: "carrot.fill", coordinate: viewModel.coordinate)
                .tint(.orange)
        }
        .mapControlVisibility(.hidden)
    }
}

#Preview {
    FarmerDetailsView(
        viewModel: FarmerDetailsViewModel(
            farmer: FarmerPlace(
                name: "Mon Maraîcher",
                location: Location(
                    latitude: 43.65,
                    longitude: 3.9,
                    city: "Montpellier"
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
