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
        Map(coordinateRegion: $mapViewModel.region,
            showsUserLocation: true)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MapView()
}
