//
//  MapView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 22/02/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    var body: some View {
<<<<<<< Updated upstream
        
        Text("Hello world!")
=======
        Map(position: $viewModel.userPosition, selection: $viewModel.selectedFarmerPlace) {
            
            ForEach(viewModel.allFarmerPlaces, id: \.id) { place in
                Marker(place.name, coordinate: CLLocationCoordinate2D(latitude: place.location.latitude, longitude: place.location.longitude)).tag(place)
            }
            
            UserAnnotation()
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear(perform: viewModel.onViewAppear)
>>>>>>> Stashed changes
    }
}

#Preview {
    MapView()
}
