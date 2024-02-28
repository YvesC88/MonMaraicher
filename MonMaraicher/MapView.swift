//
//  MapView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 22/02/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        Map(position: $viewModel.userPosition, selection: $viewModel.selectedFarmerPlace) {
            
            ForEach(viewModel.allFarmerPlaces, id: \.id) { place in
                Marker(place.name, systemImage: "carrot.fill", coordinate: CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude))
                    .tag(place)
                    .tint(.orange)
            }
            
            UserAnnotation()
            
        }
        .onChange(of: viewModel.selectedFarmerPlace, { _, newSelectedFarmer in
            viewModel.showDetails = newSelectedFarmer != nil
        })
        .sheet(isPresented: $viewModel.showDetails, content: {
            FarmerDetailsView(farmer: viewModel.selectedFarmerPlace ?? FarmerPlace(name: "Unknow farmer", location: Location(latitude: 0, longitude: 0, locality: ""), image: []))
                .presentationDetents([.medium, .large])
        })
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear(perform: viewModel.onViewAppear)
    }
}

#Preview {
    MapView()
}
