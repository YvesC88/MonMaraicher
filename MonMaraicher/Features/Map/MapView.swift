//
//  MapView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 22/02/2024.
//

import SwiftUI
import MapKit

struct MapView: View {

    @StateObject private var viewModel = MapViewModel(farmerService: FarmerService())

    var body: some View {
        Map(position: $viewModel.mapCameraPosition, selection: $viewModel.selectedFarmer) {

            ForEach(viewModel.allFarmers, id: \.id) { farmer in
                Marker(farmer.title,
                       systemImage: farmer.systemImageName,
                       coordinate: CLLocationCoordinate2D(latitude: farmer.location.latitude, longitude: farmer.location.longitude))
                .tag(farmer)
                .tint(.orange)
            }

            UserAnnotation()

        }
        .sheet(item: $viewModel.selectedFarmer) { farmer in
            FarmerDetailsView(viewModel: FarmerDetailsViewModel(farmer: farmer))
                .presentationDetents([.medium, .large])
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear(perform: viewModel.onViewAppear)
        .overlay(alignment: .bottom) {
            nearbyFarmerButton
        }
    }
}

extension MapView {

    private var nearbyFarmerButton: some View {
        Button {
            viewModel.onNearbyFarmerButtonTapped()
        } label: {
            Image(systemName: viewModel.imageSystemNameSearchButton)
                .font(.title)
                .padding(16)
                .foregroundStyle(.blue)
                .background(Circle()
                    .fill(.thinMaterial))
        }
        .alert(viewModel.titleError, isPresented: $viewModel.isErrorSearchFarmerPresented, actions: {
        })
        .padding(32)
        .shadow(radius: 8)
    }
}

#Preview {
    MapView()
}
