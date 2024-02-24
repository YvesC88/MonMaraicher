//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {
    
    @Published var position: MapCameraPosition = .userLocation(fallback: .automatic)
}
