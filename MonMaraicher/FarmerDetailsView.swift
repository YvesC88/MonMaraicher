//
//  FarmerDetailsView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 27/02/2024.
//

import SwiftUI
import MapKit

struct FarmerDetailsView: View {
    
    @State var farmer: FarmerPlace
    
    @StateObject private var viewModel = MapViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
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
            .ignoresSafeArea()
            .overlay(closeButton, alignment: .topTrailing)
            .background(.thinMaterial)
        }
    }
}

#Preview {
    FarmerDetailsView(farmer: FarmerPlace(name: "Maraîchers Bio de Grabels de Montpellier", location: Location(latitude: 34, longitude: 34, locality: "Montpellier"), image: ["farmer1", "farmer2", "farmer3"]))
}

extension FarmerDetailsView {
    
    private var imageSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(farmer.image, id: \.self) {
                    Image($0)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(.rect(cornerRadius: 16))
                        .padding(5)
                }
            }
            .padding(5)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text(farmer.name)
                .font(.title)
                .bold()
            Text(farmer.location.locality)
                .foregroundStyle(.secondary)
        })
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bienvenue à la ferme de William, où la nature prospère en harmonie. William cultive une grande variété de fruits et légumes avec amour et respect pour l'environnement.\nSans pesticides ni produits chimiques synthétiques, sa ferme est un havre de biodiversité où les méthodes agricoles durables préservent la terre pour les générations futures.")
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
                .font(.headline)
                .padding(12)
                .background(.thinMaterial)
                .clipShape(.circle)
                .shadow(radius: 8)
                .padding()
        }
    }
    
    private var mapSection: some View {
        Map(position: $viewModel.selectedFarmerPosition) {
            Marker(farmer.name, systemImage: "carrot.fill", coordinate: CLLocationCoordinate2D(latitude: farmer.location.latitude, longitude: farmer.location.longitude))
                .tint(.orange)
        }
    }
}
