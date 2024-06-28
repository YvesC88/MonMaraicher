//
//  MonMaraicherApp.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 27/06/2024.
//

import SwiftUI

@main
struct MonMaraicherApp: App {

    @AppStorage("hasCompletedOnBoarding") var hasCompletedOnBoarding: Bool = false

    var body: some Scene {
            WindowGroup {
                if hasCompletedOnBoarding {
                    MapView()
                } else {
                    OnBoardingView()
                }
            }
        }
}
