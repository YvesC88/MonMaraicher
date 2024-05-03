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
        .onChange(of: viewModel.hasUserAcceptedLocation ) {
            viewModel.onReloadingFarmersButtonTapped()
        }
        .onAppear(perform: viewModel.onViewAppear)
        .overlay(alignment: .bottom) {
            HStack {
                nearbyFarmerButton
                reloadFarmersButton
                    .disabled(viewModel.farmersLoadingInProgress)
            }
        }
        .overlay {
            if viewModel.farmersLoadingInProgress {
                ProgressView()
                    .controlSize(.large)
            }
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
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .padding(20)
                .background(Circle().fill(.ultraThinMaterial))

        }
        .shadow(radius: 12)
        .padding(32)
    }

    private var reloadFarmersButton: some View {
        Button {
            viewModel.onReloadingFarmersButtonTapped()
        } label: {
                Image(systemName: viewModel.imageSystemNameReloadButton)
        }
        .font(.system(size: 17, weight: .bold, design: .rounded))
        .padding(20)
        .background(Circle().fill(.ultraThinMaterial))
        .shadow(radius: 12)
        .padding(32)
    }
}

#Preview {
    MapView()
}
