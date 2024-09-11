//
//  ThreeInRowGameView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import SwiftUI
import SpriteKit

struct ThreeInRowGameView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    private let settingsTimerUDKey = "settingsThreeInRowTimerUDKey"
    
    private let defaultTimerSeconds = 30
    @State private var strikes = 0
    @State private var timer: Timer?
    @State private var timeRemaining = 30
    @State private var gameWon = false
    @State private var gameLost = false
    @State private var isPlaying: Bool = false
    @State private var isShowSettings: Bool = false
    @State private var selectedDificulty: GameDifficulty = .easy
    @State private var isTimerOn: Bool
    @State private var isOnPause: Bool = false
    
    init() {
        _isTimerOn = State(initialValue: (UserDefaults.standard.value(forKey: settingsTimerUDKey) as? Bool) ?? true)
        _timeRemaining = State(initialValue: defaultTimerSeconds)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    if isPlaying {
                        if !isOnPause {
                            VStack {
                                if isTimerOn {
                                    Text("Time: \(timeRemaining)")
                                        .font(.largeTitle)
                                        .foregroundStyle(.appText)
                                        .shadow(color: .black, radius: 1)
                                        .padding()
                                }
                                
                                Text("Strikes: \(strikes)")
                                    .font(.title)
                                    .foregroundStyle(.appText)
                                    .shadow(color: .black, radius: 1)
                                    .padding()
                                
                                SpriteView(scene: ThreeInRowGameScene(size: CGSize(width: geometry.size.width, height: geometry.size.width), strikes: $strikes, difficulty: selectedDificulty))
                                    .frame(width: geometry.size.width, height: geometry.size.width)
                                
                            }
                            .padding(.top, 60)
                            .padding(.bottom, 120)
                        } else {
                            GamePauseView()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    isOnPause = false
                                }
                                .ignoresSafeArea()
                        }
                    } else {
                        GameStartView(title: "Swap fishes to have 3 same in row!") {
                            isPlaying = true
                            startTimer()
                        } onSettngs: {
                            isShowSettings.toggle()

                        }
                    }
                }
            }
            
            if gameWon || gameLost {
                Color.black
                    .opacity(0.7)
                    .ignoresSafeArea()
            }
            
            if gameWon || gameLost {
                endGameView
            }
        }
        .onChange(of: scenePhase) { oldValue, newPhase in
            switch newPhase {
            case .background:
                isOnPause = true
            case .inactive:
                isOnPause = true
            case .active:
                isOnPause = false
            @unknown default:
                isOnPause = false
            }
        }
        .onChange(of: isTimerOn, { oldValue, newValue in
            UserDefaults.standard.setValue(newValue, forKey: settingsTimerUDKey)
            UserDefaults.standard.synchronize()
        })
        .overlay(alignment: .topLeading) {
            Button {
                AppFeedbackGenerator.occureImpact(with: .light)

                dismiss()
            } label: {
                Image.appBackNavigationIcon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(AppPrimaryButtonStyle(padding: 12))
            .padding(.top, 60)
            .padding(.horizontal, 16)
        }
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .background {
            Image(.threeInRowBackground)
                .resizable()
                .scaledToFill()
                .layoutPriority(-1)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $isShowSettings, content: {
            SettingsView(difficulty: $selectedDificulty, timerIsOn: $isTimerOn, onClose: {
                isShowSettings.toggle()
            })
            .presentationDetents([.height(300)])
        })
    }
    
    private var endGameView: some View {
        VStack(spacing: 40) {
            if gameWon {
                LeaderboardView()
                    .layoutPriority(-1)
            }
            VStack(spacing: 40) {
                if gameWon {
                    Text("You Won!")
                        .font(.largeTitle)
                        .foregroundColor(.green)
                } else if gameLost {
                    Text("Try Lost!")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }
                
                Button {
                    AppFeedbackGenerator.occureImpact(with: .light)

                    restartGame()
                } label: {
                    Text("Try again")
                }
                .buttonStyle(AppPrimaryButtonStyle())
            }
            .layoutPriority(999)
        }
        .padding(.vertical, 100)
    }
    
    private func restartGame() {
        gameWon = false
        gameLost = false
        timer?.invalidate()
        timer = nil
        strikes = 0
        timeRemaining = defaultTimerSeconds
        
        startTimer()
    }
    
    private func startTimer() {
        guard isTimerOn else {
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                if self.strikes >= requiredStrikes(for: selectedDificulty) {
                    self.gameWon = true
                } else {
                    self.gameLost = true
                }
            }
        }
    }
    
    func requiredStrikes(for difficulty: GameDifficulty) -> Int {
        switch difficulty {
        case .easy:
            return 3
        case .hard:
            return 6
        }
    }
}

#Preview {
    ThreeInRowGameView()
}
