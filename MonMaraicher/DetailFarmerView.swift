//
//  DetailFarmerView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 27/02/2024.
//

import SwiftUI
import MapKit

struct DetailFarmerView: View {
    
    @State var selectedFarmer: FarmerPlace?
    
    @Binding var show: Bool
    
    var body: some View {
        
        Text(selectedFarmer?.name ?? "")
            .padding()
        Button {
            show.toggle()
            selectedFarmer = nil
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .foregroundStyle(.gray, Color(.systemGray6))
        }
    }
}

#Preview {
    DetailFarmerView(selectedFarmer: FarmerPlace(name: "Chez William", location: Location(latitude: 34, longitude: 34)), show: .constant(false))
}
