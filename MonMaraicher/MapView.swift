//
//  MapView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 22/02/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some View {
        Map(position: $mapViewModel.position) {
            
//            ForEach(placeList, id: \.id) { place in
//                Marker(place.title, coordinate: place.coordinate)
//            }
            
            UserAnnotation()
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    MapView()
}
