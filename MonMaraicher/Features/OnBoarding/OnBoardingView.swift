//
//  OnBoardingView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 25/06/2024.
//

import SwiftUI

struct OnBoardingView: View {

    @State private var currentIndex = 0

    @AppStorage("hasCompletedOnBoarding") var hasCompletedOnBoarding: Bool = false

    var elements: [OnBoarding] = [
        OnBoarding(title: "Bienvenue", description: "Découvre les meilleurs producteurs bio près de chez toi !", image: "welcome", buttonTitle: "Continuer", topTrailingButton: ""),
        OnBoarding(title: "Soutenir", description: "Soutenez l'agriculture durable et savourez des produits frais et authentiques !", image: "support", buttonTitle: "Continuer", topTrailingButton: ""),
        OnBoarding(title: "Localisation", description: "Active la localisation pour découvrir plus de 32 000 producteurs en France, Corse et DOM-TOM.", image: "location", buttonTitle: "Activer", topTrailingButton: "Plus tard")
        ]

    var body: some View {
            TabView(selection: $currentIndex) {
                ForEach(0..<elements.count, id: \.self) { index in
                    OnBoardingCardView(onBoarding: elements[index], onNext: {
                        withAnimation {
                            if currentIndex < elements.count - 1 {
                                currentIndex += 1
                            } else {
                                hasCompletedOnBoarding = true
                            }
                        }
                    })
                    .tag(index)
                }
            }
            .ignoresSafeArea()
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .persistentSystemOverlays(.hidden)
        }
}

#Preview {
    OnBoardingView()
}
