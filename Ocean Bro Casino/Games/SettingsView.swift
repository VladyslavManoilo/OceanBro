//
//  SettingsView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI

struct SettingsView: View {
    @Binding var difficulty: GameDifficulty
    @Binding var timerIsOn: Bool

    let onClose: (() -> Void)
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                HStack {
                    Text("Settings")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.appText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 40)
                    
                    Button {
                        AppFeedbackGenerator.occureImpact(with: .light)

                        onClose()
                    } label: {
                        ZStack {
                            Image.appSmallCloseIcon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .frame(width: 34, height: 34)
                        .contentShape(Rectangle())
                    }
                }
                
                VStack(spacing: 12) {
                    Text("Difficulty")
                        .font(.title)
                        .foregroundStyle(.appText)
                    
                    Picker("What is your favorite color?", selection: $difficulty) {
                        ForEach(GameDifficulty.allCases) { difficulty in
                            Text(difficulty.title)
                                .tag(difficulty)
                        }
                    }
                    .tint(.appButtonBackground)
                    .pickerStyle(.segmented)
                    
                    Divider()
                    
                    HStack {
                        Text("Timer")
                            .font(.title)
                            .foregroundStyle(.appText)
                        
                        Spacer()
                        
                        Toggle("", isOn: $timerIsOn)
                            .tint(.accent)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView(difficulty: .constant(.easy), timerIsOn: .constant(true), onClose: {})
}
