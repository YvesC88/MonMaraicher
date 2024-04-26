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
                descriptionSection
                VStack(alignment: .leading, spacing: 16) {
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

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.title)
                .font(.title)
                .bold()
            ForEach(viewModel.farmerAddressesTypes, id: \.self) { type in
                Text(type)
                    .font(.subheadline)
            }
            Divider()
        }
        .padding()
        .padding(.trailing)
    }

    private var descriptionSection: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 120))]) {
                ForEach(viewModel.products, id: \.id) { product in
                    Text(product.name)
                        .padding(12)
                        .lineLimit(2)
                        .background(.blue)
                        .font(.subheadline)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 20))
                }
            }
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
        .shadow(radius: 4)
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
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Adresse")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    Text(viewModel.address)
                        .font(.callout)
                }
                Spacer()
                directionButton
                    .frame(width: 80, height: 35)
                    .background(.ultraThinMaterial)
                    .clipShape(.capsule)
                    .padding()
                    .shadow(radius: 2)
            }
            Divider()
            Text("Téléphone")
                .foregroundStyle(.secondary)
                .font(.subheadline)
            Text(viewModel.phoneNumber ?? "")
                .font(.callout)
            Divider()
            Text("Site Web")
                .foregroundStyle(.secondary)
                .font(.subheadline)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 4)
    }
}

#Preview {
    // TODO: simplify this code
    FarmerDetailsView(viewModel: FarmerDetailsViewModel(marker: .init(farmer: .init(id: 1, businessName: "chez william", personalPhone: nil, businessPhone: nil, addresses: [.init(id: 1, place: "20 rue de la paix", zipCode: "75000", city: "paris", latitude: 48.86935, longitude: 2.331314, farmerAddressesTypes: ["Siège social"])], products: [.init(id: 1, name: "Tomates")]), address: .init(id: 2, place: "300 rue de la paix", zipCode: "75000", city: "paris", latitude: 48.45012, longitude: 2.354564, farmerAddressesTypes: ["siège social"]))))
}
