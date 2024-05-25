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

    @State var showingProductsList = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                titleSection
                Divider()
                HStack {
                    distanceSection
                    Divider()
                    productsSection
                }
                Divider()
                productsScrollingSection
                Divider()
                mapSection
                Divider()
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
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.blue.gradient)
            ForEach(viewModel.farmerAddressesTypes, id: \.self) { addressType in
                Text(addressType)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            }
        }
        .padding(.trailing)
    }

    private var distanceSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).foregroundStyle(.regularMaterial)
            VStack {
                Text("distance".uppercased())
                    .font(.system(size: 10))
                    .foregroundStyle(.secondary)
                Text(viewModel.distance)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
        }
    }

    private var productsSection: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
            VStack {
                Button {
                    self.showingProductsList.toggle()
                } label: {
                    Text("Liste des produits")
                        .foregroundStyle(.white)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
                .sheet(isPresented: $showingProductsList) {
                    ProductsView(products: viewModel.products)
                        .presentationDetents([.medium, .large])
                }
            }
        }
        .foregroundStyle(.blue.gradient)
        .frame(height: 60)
    }

    private var productsScrollingSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(viewModel.getProductsImagesNames(), id: \.self) { image in
                    GeometryReader { proxy in
                        let scale = viewModel.getScale(proxy: proxy)
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .scaleEffect(CGSize(width: scale, height: scale))
                    }
                    .frame(width: 60, height: 60)
                }
            }
            .padding(25)
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(.ultraThinMaterial))
        .clipShape(.rect(cornerRadius: 20))
    }

    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .padding(8)
                .background(Circle().fill(.regularMaterial))
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
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
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
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
                Spacer()
                if viewModel.phoneNumber != nil {
                    phoneButton
                }
            }
            Divider()
            HStack {
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    Text(viewModel.email ?? "Aucune adresse email")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
                Spacer()
                if viewModel.email != nil {
                    emailButton
                }
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
                }
            }
            .font(.system(size: 15, weight: .semibold, design: .rounded))
        }
        .padding()
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 20))
    }

    private var directionButton: some View {
        Button {
            viewModel.onDirectionButtonTapped()
        } label: {
            Image(systemName: viewModel.directionButtonImageSystemName).foregroundStyle(.white.gradient)
                .frame(width: 80, height: 40)
                .background(RoundedRectangle(cornerRadius: 20).fill(.blue.gradient))
                .padding()
        }
    }

    @ViewBuilder
    private var phoneButton: some View {
        if let phoneCallURL = viewModel.phoneCallURL {
            self.makeLink(with: phoneCallURL, image: viewModel.phoneButtonImageSystemName)
        }
    }

    @ViewBuilder
    private var emailButton: some View {
        if let emailURL = viewModel.emailURL {
            self.makeLink(with: emailURL, image: viewModel.emailButtonImageSystemName)
        }
    }

    private func makeLink(with url: URL, image: String) -> some View {
        Link(destination: url) {
            Image(systemName: image)
                .foregroundStyle(.white.gradient)
                .frame(width: 80, height: 40)
                .background(RoundedRectangle(cornerRadius: 20).fill(.blue.gradient))
                .padding()
        }
    }
}

#Preview {
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
                            name: "huile d'olive, brute"
                        ),
                        .init(
                            id: 2,
                            name: "huile d'olive et ses fractions"
                        ),
                        .init(
                            id: 3,
                            name: "Poires"
                        ),
                        .init(
                            id: 4,
                            name: "pomelos et pamplemousses"
                        ),
                        .init(
                            id: 5,
                            name: "Thym"
                        )
                    ]
                ),
                address: .init(
                    id: 2,
                    place: "300 rue de la paix",
                    zipCode: "75000",
                    city: "paris",
                    latitude: 37.337838,
                    longitude: -122.01,
                    farmerAddressesTypes: ["siège social"]
                )
            )
        )
    )
}
