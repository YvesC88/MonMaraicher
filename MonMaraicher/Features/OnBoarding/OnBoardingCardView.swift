//
//  MyFarmerCardView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 25/06/2024.
//

import SwiftUI

struct OnBoarding {
    let title: String
    let description: String
    let image: String
    let buttonTitle: String
    let topTrailingButton: String
}

struct OnBoardingCardView: View {

    let onBoarding: OnBoarding
    var onNext: () -> Void

    @AppStorage("hasSkip") var hasSkip: Bool = false

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Image(onBoarding.image)
                    .resizable()
                    .scaledToFit()
                Text(onBoarding.title)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                Text(onBoarding.description)
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .multilineTextAlignment(.center)
            }
            .padding()
            .foregroundStyle(.black)
            Spacer()
            Button(action: onNext) {
                Text(onBoarding.buttonTitle)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(18)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.accent))
                    .padding()
            }
            .padding(.bottom, 20)
        }
        .overlay(alignment: .topTrailing) {
            Button {
                onNext()
                hasSkip = true
            } label: {
                Text(onBoarding.topTrailingButton)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
            }
            .padding(.horizontal, 20)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(.white)
    }
}

#Preview {
    OnBoardingCardView(onBoarding: .init(title: "Bienvenue", description: "Active la localisation pour découvrir plus de 32 000 producteurs en France, Corse et DOM-TOM.", image: "welcome", buttonTitle: "Activer", topTrailingButton: "Plus tard"), onNext: {})
}
