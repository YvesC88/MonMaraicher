//
//  LoaderAnimationView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 28/05/2024.
//

import SwiftUI

struct LoaderAnimationView: View {

    @State var trimCircleEnd: CGFloat = 0.4
    @State var rotationDegree: Angle = .degrees(0)

    let trackerRotation: Double = 1.75
    let animationDuration: Double = 0.7

    var body: some View {
        animation
    }
}

extension LoaderAnimationView {

    private var animation: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .fill(.blue.opacity(0.2))
            Circle()
                .trim(from: 0.2, to: trimCircleEnd)
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .fill(LinearGradient(colors: [.red, .white], startPoint: .leading, endPoint: .trailing))
                .rotationEffect(rotationDegree)
                .onAppear {
                    animationLoader()
                    Timer.scheduledTimer(withTimeInterval: (trackerRotation * animationDuration) + animationDuration, repeats: true) { _ in
                        self.animationLoader()
                    }
                }
        }
        .frame(width: 32, height: 32)
    }

    private func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation) + .degrees(150)
    }

    private func animationLoader() {
        withAnimation(.bouncy(duration: animationDuration * 2)) {
            rotationDegree = .degrees(-60)
            trimCircleEnd = 0.5
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeInOut(duration: trackerRotation * animationDuration)) {
                self.rotationDegree += self.getRotationAngle()
            }
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(.easeOut(duration: (trackerRotation * animationDuration) / 2.25)) {
                trimCircleEnd = 0.8
            }
        }
        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            rotationDegree = .degrees(60)
            withAnimation(.easeOut(duration: animationDuration)) {
                trimCircleEnd = 0.3
            }
        }
    }
}

#Preview {
    LoaderAnimationView()
}
