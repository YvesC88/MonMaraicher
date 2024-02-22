//
//  MapView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 22/02/2024.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var mapViewModel = MapViewModel()
    
    var body: some View {
        Map(coordinateRegion: $mapViewModel.region,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow))
        .ignoresSafeArea()
        .onAppear {
            mapViewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

#Preview {
    MapView()
}
