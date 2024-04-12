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
                ForEach(farmer.adressesOperateurs, id: \.id) { location in
                    Marker(farmer.raisonSociale, systemImage: "laurel.leading", coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long))
                        .tag(farmer)
                        .tint(.orange)
                }
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
        .alert(isPresented: $viewModel.isAlertPresented, error: viewModel.nearbyButtonAlert) { alert in
            if viewModel.hasTextField {
                TextField(alert.textFieldTitle ?? "", value: $viewModel.searchScope, format: .number)
                    .keyboardType(.numberPad)
                Button(alert.confirmButtonTitle) {
                    viewModel.isAlertPresented = false
                }
            } else {
                Button(alert.confirmButtonTitle) {
                    viewModel.openSettings()
                }
                Button(alert.cancelButtonTitle ?? "", role: .cancel) {
                    viewModel.isAlertPresented = false
                }
            }
        } message: { alert in
            Text(alert.message)
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
                .background(Circle().fill(.thinMaterial))
        }
        .padding(32)
        .shadow(radius: 8)
    }
}

#Preview {
    MapView()
}
