//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 22/02/2024.
//

import MapKit

enum MapParams {
    static let startingLocation = CLLocationCoordinate2D(latitude: 43.60033701544479, longitude: 3.90822089397965)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: MapParams.startingLocation, span: MapParams.defaultSpan)
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Localisation restreinte")
        case .denied:
            print("Vous avez refusé de localiser votre position avec l'application")
        case .authorizedAlways:
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse:
            manager.requestLocation()
        default:
            ()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map { region = MKCoordinateRegion(center: $0.coordinate,
                                                         span: MapParams.defaultSpan) }
        manager.stopUpdatingLocation()
    }
}
