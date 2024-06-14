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
        .mapControlVisibility(.hidden)
        .mapStyle(.standard(elevation: .realistic))
        // FIXME: - method to rework
        .onChange(of: viewModel.hasUserAcceptedLocation) {
            viewModel.reloadingFarmers()
        }
        .onAppear {
            viewModel.onViewAppear()
        }
        .overlay(alignment: .bottom) {
            nearbyFarmerButton
        }
        .overlay {
            if viewModel.farmersLoadingInProgress && viewModel.hasUserAcceptedLocation {
                LoaderAnimationView()
            }
        }
        .overlay(alignment: .topTrailing) {
            VStack(spacing: 16) {
                userLocationButton
                filterButton
            }
            .shadow(radius: 16)
            .padding()
        }
        .overlay(alignment: .trailing) {
            if viewModel.isFilterViewVisible {
                filterProductView
                    .transition(.move(edge: .trailing))
            }
        }
        .onMapCameraChange(frequency: .onEnd) { mapCameraUpdate in
            viewModel.onMapCameraChange(currentMapCameraPosition: mapCameraUpdate.camera.centerCoordinate)
        }
        .sheet(item: $viewModel.farmerDetailsViewModel, onDismiss: {
            withAnimation {
                viewModel.deselectAnnotation()
            }
        }, content: { farmerViewModel in
            FarmerDetailsView(viewModel: farmerViewModel)
                .presentationDetents([.medium, .large])
        })
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
            withAnimation {
                viewModel.onNearbyFarmerButtonTapped()
            }
        } label: {
            Image(systemName: viewModel.imageSystemNameSearchButton)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(20)
                .background(Circle().fill(.regularMaterial))
        }
        .shadow(radius: 12)
        .padding(32)
    }

    private var userLocationButton: some View {
        Button {
            withAnimation {
                viewModel.focusUserLocation()
            }
        } label: {
            Image(systemName: "location.fill")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(10)
                .background(Circle().fill(.thinMaterial))
        }
    }

    private var filterButton: some View {
        Button {
            withAnimation(.smooth(duration: 0.5)) {
                viewModel.isFilterViewVisible.toggle()
            }
        } label: {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(10)
                .background(Circle().fill(.thinMaterial))
        }
    }

    private var filterProductView: some View {
        VStack(spacing: 5) {
            ForEach(Array(viewModel.productCategories.keys.sorted()), id: \.self) { category in
                Button {
                    viewModel.filterProducts(by: category)
                } label: {
                    Text(category)
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .frame(width: 70, height: 35)
                        .foregroundStyle(.white)
                        .background(RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.selectedCategory == category ? .gray : .orange))
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.regularMaterial))
        .padding(.trailing, 5)
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
