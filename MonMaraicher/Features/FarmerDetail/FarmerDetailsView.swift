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
            VStack(alignment: .leading, spacing: 16) {
                titleSection
                Divider()
                descriptionSection
                Divider()
                mapSection
                contactSection
            }
            .padding()
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
        }
        .padding(.trailing)
    }

    private var descriptionSection: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110))], spacing: 10) {
            ForEach(viewModel.products, id: \.id) { product in
                ZStack {
                    Rectangle()
                        .frame(width: 110, height: 60)
                        .foregroundStyle(.blue)
                        .clipShape(.rect(cornerRadius: 16))
                    Text(product.name)
                        .padding(16)
                        .lineLimit(2)
                        .foregroundStyle(.white)
                }
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
                .shadow(radius: 8)
                .padding()
        }
    }

    private var mapSection: some View {
        Map(position: .constant(.automatic), bounds: .init(minimumDistance: 1000)) {
            Marker(viewModel.title, systemImage: viewModel.markerSystemImageName, coordinate: viewModel.coordinate)
                .tint(.orange)
        }
        .aspectRatio(2, contentMode: .fit)
        .clipShape(.rect(cornerRadius: 16))
        .shadow(radius: 8)
        .allowsHitTesting(false)
        .mapControlVisibility(.hidden)
    }

    private var contactSection: some View {
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
            }
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Téléphone")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    Text(viewModel.phoneNumber ?? "Aucun numéro disponible")
                        .font(.callout)
                }
                Spacer()
                phoneButton
            }
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    Text(viewModel.email ?? "Aucune adresse email")
                        .font(.callout)
                }
                Spacer()
                emailButton
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Site Web")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                if !viewModel.websites.isEmpty {
                    ForEach(viewModel.websites, id: \.id) { website in
                        Text(.init(viewModel.formatWebsite(website)))
                    }
                } else {
                    Text("Aucun site web")
                        .font(.callout)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 8)
    }

    private var directionButton: some View {
        Button {
            viewModel.onDirectionButtonTapped()
        } label: {
            Image(systemName: viewModel.directionButtonImageSystemName)
        }
        .frame(width: 80, height: 40)
        .overlay(RoundedRectangle(cornerRadius: 32)
            .stroke(.blue, lineWidth: 1))
        .padding()
    }

    private var phoneButton: some View {
        VStack {
            if viewModel.phoneNumber != nil {
                Link(destination: viewModel.phoneCallURL!) {
                    Image(systemName: viewModel.phoneButtonImageSystemName)
                }
                .frame(width: 80, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 32)
                    .stroke(.blue, lineWidth: 1))
                .padding()
            }
        }
    }

    private var emailButton: some View {
        VStack {
            if viewModel.email != nil {
                Button {
                    viewModel.onMailButtonTapped()
                } label: {
                    Image(systemName: viewModel.emailButtonImageSystemName)
                }
                .frame(width: 80, height: 40)
                .overlay(RoundedRectangle(cornerRadius: 32)
                    .stroke(.blue, lineWidth: 1))
                .padding()
            }
        }
    }
}

#Preview {
    // TODO: simplify this code
    FarmerDetailsView(
        viewModel: FarmerDetailsViewModel(
            marker: .init(
                farmer: .init(
                    id: 1,
                    businessName: "chez william",
                    personalPhone: "0606060606",
                    email: "test@test.fr",
                    businessPhone: nil,
                    websites: [
                        .init(
                            id: 1,
                            url: "https://www.instagram.com/dilemme.bio/",
                            active: true,
                            operatorId: 1,
                            websiteType: .init(
                                id: 1,
                                name: "Instagram"
                            )
                        ),
                        .init(
                            id: 2,
                            url: "https://www.dilemme.bio",
                            active: true,
                            operatorId: 1,
                            websiteType: .init(
                                id: 1,
                                name: "Facebook"
                            )
                        )
                    ],
                    addresses: [.init(
                        id: 1,
                        place: "20 rue de la paix",
                        zipCode: "75000",
                        city: "paris",
                        latitude: 48.86935,
                        longitude: 2.331314,
                        farmerAddressesTypes: ["Siège social"]
                    )],
                    products: [
                        .init(
                            id: 1,
                            name: "Fruits à pépins et à coques"
                        ),
                        .init(
                            id: 2,
                            name: "Pomme de table"
                        ),
                        .init(
                            id: 3,
                            name: "Poires"
                        ),
                        .init(
                            id: 4,
                            name: "Coings"
                        ),
                        .init(
                            id: 5,
                            name: "Abricots"
                        ),
                        .init(
                            id: 6,
                            name: "Miel"
                        ),
                        .init(
                            id: 7,
                            name: "Thym"
                        )
                    ]
                ),
                address: .init(
                    id: 2,
                    place: "300 rue de la paix",
                    zipCode: "75000",
                    city: "paris",
                    latitude: 48.45012,
                    longitude: 2.354564,
                    farmerAddressesTypes: ["siège social"]
                )
            )
        )
    )
}
