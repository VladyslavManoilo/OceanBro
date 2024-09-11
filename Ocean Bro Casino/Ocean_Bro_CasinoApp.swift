//
//  Ocean_Bro_CasinoApp.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import SwiftUI

@main
struct Ocean_Bro_CasinoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    UISegmentedControl.appearance().selectedSegmentTintColor = .appButtonBackground
                    UISegmentedControl.appearance().backgroundColor = UIColor.appButtonBackground.withAlphaComponent(0.3)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.appButtonText], for: .selected)
                    UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
                }
        }
    }
}
