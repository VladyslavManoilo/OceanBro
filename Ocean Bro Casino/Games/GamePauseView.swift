//
//  GamePauseView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI

struct GamePauseView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            Text("Paused")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .font(.largeTitle.bold())
                .foregroundStyle(.appText)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GamePauseView()
}
