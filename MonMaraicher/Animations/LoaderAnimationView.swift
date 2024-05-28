//
//  LoaderAnimationView.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 28/05/2024.
//

import SwiftUI

struct LoaderAnimationView: View {

    @State var circleEnd: CGFloat = 0.325

    @State var rotationDegree: Angle = .degrees(0)

    let trackerRotation: Double = 2

    let animationDuration: Double = 0.75

    var body: some View {
        animation
    }
}

extension LoaderAnimationView {

    private var animation: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .fill(.blue.opacity(0.2))
            Circle()
                .trim(from: 0.17, to: circleEnd)
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .fill(LinearGradient(colors: [.blue, .green], startPoint: .leading, endPoint: .trailing))
                .rotationEffect(rotationDegree)
                .onAppear {
                    animationLoader()
                    Timer.scheduledTimer(withTimeInterval: (trackerRotation * animationDuration) + animationDuration, repeats: true) { _ in
                        self.animationLoader()
                    }
                }
        }
        .frame(width: 40, height: 40)
    }

    private func getRotationAngle() -> Angle {
        return .degrees(360 * trackerRotation) + .degrees(120)
    }

    private func animationLoader() {
        withAnimation(.bouncy(duration: animationDuration * 2)) {
            rotationDegree = .degrees(-60)
            circleEnd = 0.5
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(.easeInOut(duration: trackerRotation * animationDuration)) {
                self.rotationDegree += self.getRotationAngle()
            }
        }
        Timer.scheduledTimer(withTimeInterval: animationDuration * 1.25, repeats: false) { _ in
            withAnimation(.easeOut(duration: (trackerRotation * animationDuration) / 2.25)) {
                circleEnd = 0.9
            }
        }
        Timer.scheduledTimer(withTimeInterval: trackerRotation * animationDuration, repeats: false) { _ in
            rotationDegree = .degrees(47.5)
            withAnimation(.easeOut(duration: animationDuration)) {
                circleEnd = 0.4
            }
        }
    }
}

#Preview {
    LoaderAnimationView()
}
