//
//  MonMaraicherApp.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 27/06/2024.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct MonMaraicherApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
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
