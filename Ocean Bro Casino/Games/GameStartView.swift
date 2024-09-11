//
//  GameStartView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI

struct GameStartView: View {
    let title: String
    let onStart: (() -> Void)
    let onSettngs: (() -> Void)
    
    var body: some View {
        ZStack {
            VStack(spacing: 60) {
                Spacer()
                
                Text(title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.appText)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
              
                VStack(spacing: 45) {
                    Button {
                        AppFeedbackGenerator.occureImpact(with: .light)

                        onStart()
                    } label: {
                        Text("Play")
                    }
                    .buttonStyle(AppSecondaryButtonStyle())
                    
                    Button {
                        AppFeedbackGenerator.occureImpact(with: .light)

                        onSettngs()
                    } label: {
                        Text("Settings")
                    }
                    .buttonStyle(AppSecondaryButtonStyle())
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 60)
            .padding(.bottom, 120)
        }
        .ignoresSafeArea()
        .background(.black.opacity(0.5))    }
}

#Preview {
    GameStartView(title: "Some game rules there", onStart: {}, onSettngs: {})
}
