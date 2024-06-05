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
                Marker(marker.title, systemImage: marker.systemImage, coordinate: marker.coordinate)
                    .tag(marker)
                    .tint(.orange)
            }
            UserAnnotation()
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
        }
        // FIXME: - method to rework
        .onChange(of: viewModel.hasUserAcceptedLocation ) {
            viewModel.reloadingFarmers()
        }
        .onAppear {
            viewModel.onViewAppear()
        }
        .overlay(alignment: .bottom) {
            HStack {
                nearbyFarmerButton
                reloadFarmersButton
                    .disabled(viewModel.farmersLoadingInProgress)
            }
        }
        .overlay {
            if viewModel.farmersLoadingInProgress && viewModel.hasUserAcceptedLocation {
                LoaderAnimationView()
            }
        }
        .overlay(alignment: .top) {
            searchAreaButton
                .disabled(viewModel.farmersLoadingInProgress)
        }
        .onMapCameraChange { mapCameraUpdate in
            viewModel.currentMapCameraPosition = mapCameraUpdate.camera.centerCoordinate
        }
        .sheet(item: $viewModel.farmerDetailsViewModel) { farmerViewModel in
            FarmerDetailsView(viewModel: farmerViewModel)
                .presentationDetents([.medium, .large])
        }
        .alert(isPresented: $viewModel.isAlertPresented, error: viewModel.nearbyButtonAlert) { alert in
            alertButtons(alert: alert)
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
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(20)
                .background(Circle().fill(.regularMaterial))

        }
        .shadow(radius: 12)
        .padding(32)
    }

    private var reloadFarmersButton: some View {
        Button {
            viewModel.onReloadingFarmersButtonTapped()
        } label: {
            Image(systemName: viewModel.imageSystemNameReloadButton)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(20)
                .background(Circle().fill(.regularMaterial))
        }
        .shadow(radius: 12)
        .padding(32)
    }

    private var searchAreaButton: some View {
        Button {
            viewModel.onSearchAreaButtonTapped()
        } label: {
            Text("Rechercher ici")
                .font(.system(size: 20, weight: .regular, design: .rounded))
                .padding()
                .background(RoundedRectangle(cornerRadius: 20).fill(.regularMaterial))
                .shadow(radius: 12)
        }
        .padding()
    }

    @ViewBuilder
    private func alertButtons(alert: MapViewModel.NearbyButtonAlert) -> some View {
        switch alert {
        case .noFarmer:
            TextField(alert.textFieldTitle ?? "", value: $viewModel.searchScope, format: .number)
                .keyboardType(.numberPad)
            Button(alert.confirmButtonTitle) {
                viewModel.isAlertPresented = false
            }
        case .noLocation:
            Button(alert.confirmButtonTitle) {
                viewModel.openSettings()
            }
            Button(alert.cancelButtonTitle ?? "", role: .cancel) {
                viewModel.isAlertPresented = false
            }
        case .noFarmerAround, .loadError:
            Button(alert.confirmButtonTitle) {
                viewModel.isAlertPresented = false
            }
        }
    }
}

#Preview {
    MapView()
}
