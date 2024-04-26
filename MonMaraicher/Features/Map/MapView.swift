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
        Map(position: $viewModel.mapCameraPosition, selection: $viewModel.selectedMarker) {

            ForEach(viewModel.allMarkers, id: \.id) { marker in
                Marker(marker.title, systemImage: marker.farmer.systemImageName, coordinate: .init(latitude: marker.address.latitude, longitude: marker.address.longitude))
                    .tag(marker)
                    .tint(.orange)
            }

            UserAnnotation()

        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear(perform: viewModel.onViewAppear)
        .overlay(alignment: .bottom) {
            nearbyFarmerButton
        }
        .sheet(item: $viewModel.farmerDetailsViewModel) { farmerViewModel in
            FarmerDetailsView(viewModel: farmerViewModel)
                .presentationDetents([.medium, .large])
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
