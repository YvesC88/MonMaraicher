//
//  MapView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 22/02/2024.
//

import SwiftUI
import MapKit
import FirebaseAnalytics

struct MapView: View {

    @AppStorage("hasSkip") var hasSkip: Bool = false
    @StateObject private var viewModel = MapViewModel(farmerService: FarmerService())

    var body: some View {
        Map(position: $viewModel.mapCameraPosition, selection: $viewModel.selectedMarker) {
            ForEach(viewModel.allMarkers, id: \.id) { marker in
                Marker(marker.title, systemImage: marker.image, coordinate: marker.coordinate)
                    .tag(marker)
                    .tint(.accent)
            }
            UserAnnotation()
        }
        .mapControlVisibility(.hidden)
        .mapStyle(.standard(elevation: .realistic))
        .onChange(of: viewModel.hasUserAcceptedLocation) {
            viewModel.reloadingFarmers()
        }
        .onAppear {
            if !hasSkip {
                viewModel.onViewAppear()
            }
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
            .padding(10)
        }
        .overlay(alignment: .trailing) {
            if viewModel.isFilterViewVisible {
                filterProductView
                    .transition(.move(edge: .trailing))
                    .padding(.top, 50)
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
                Analytics.logEvent("userLocationButton_tapped", parameters: nil)
            }
        } label: {
            Image(systemName: "location.fill")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(12)
                .background(Circle().fill(.regularMaterial))
        }
    }

    private var filterButton: some View {
        Button {
            withAnimation(.smooth(duration: 1)) {
                viewModel.isFilterViewVisible.toggle()
            }
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding(12)
                    .background(Circle().fill(.regularMaterial))

                if viewModel.selectedCategories.count > 0 {
                    Text("\(viewModel.selectedCategories.count)")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(width: 15, height: 15)
                        .background(.accent)
                        .clipShape(.circle)
                }
            }
        }
    }

    private var filterProductView: some View {
        VStack(spacing: 5) {
            ForEach(allProductsCategories, id: \.name) { category in
                Button {
                    viewModel.onFilterProductsButtonTapped(by: category.name)
                } label: {
                    VStack(spacing: 0) {
                        Image(category.image.rawValue)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                        Text(category.name)
                            .foregroundStyle(.accent)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                    }
                    .frame(width: 62, height: 30)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.regularMaterial)
                        .shadow(radius: 16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.accent, lineWidth: 2)
                                .opacity(viewModel.selectedCategories.contains(category.name) ? 1 : 0))
                )
            }
        }
        .padding(.trailing, 10)
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
