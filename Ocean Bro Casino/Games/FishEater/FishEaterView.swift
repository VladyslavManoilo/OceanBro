//
//  FishEaterView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI
import SpriteKit

struct FishEaterView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    private let settingsTimerUDKey = "settingsFishEaterTimerUDKey"
    
    @State private var isPlaying: Bool = false
    @State private var isOnPause: Bool = false
    @State private var isShowSettings: Bool = false
    @State private var tapsNumber: Int = 0
    @State private var selectedGameDifficulty: GameDifficulty = .easy
    private let defaultTimerSeconds = 30
    @State private var timer: Timer?
    @State private var timeRemaining = 30
    @State private var isGameFinished: Bool = false
    @State private var isTimerOn: Bool
    
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
                            SpriteView(scene: FishEaterScene(size: geometry.size, collectedTaps: $tapsNumber, difficulty: selectedGameDifficulty), options: [.allowsTransparency])
                                .overlay(alignment: .top) {
                                    if isTimerOn {
                                        Text("Time: \(timeRemaining)")
                                            .font(.largeTitle)
                                            .foregroundStyle(.appText)
                                            .shadow(color: .black, radius: 1)
                                            .frame(height: 44)
                                            .padding(.top, 60)
                                    }
                                }
                                .overlay(alignment: .topTrailing) {
                                    ZStack {
                                        Text("Strikes: \(tapsNumber)")
                                            .font(.body)
                                            .foregroundStyle(.appText)
                                            .shadow(color: .black, radius: 1)
                                            .padding()
                                    }
                                    .frame(height: 44)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.4)))
                                    .padding(.top, 60)
                                    .padding(.horizontal, 16)
                                    
                                }
                        } else {
                            GamePauseView()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    isOnPause = false
                                }
                                .ignoresSafeArea()
                        }
                    } else {
                        GameStartView(title: "Catch fishes as many as you can!") {
                            isPlaying = true
                            startTimer()
                        } onSettngs: {
                            isShowSettings.toggle()
                        }
                    }
                }
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
            }
            
            if isGameFinished {
                ZStack {
                    Color.black
                        .opacity(0.7)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 40) {
                        LeaderboardView()
                            .layoutPriority(-1)
                        
                        VStack(spacing: 40) {
                            Text("Your Result is: \(tapsNumber)")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                            
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
            }
            
        }
        .navigationBarBackButtonHidden()
        .background {
            Image(.fishEaterBackground)
                .resizable()
                .scaledToFill()
                .layoutPriority(-1)
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
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
        .sheet(isPresented: $isShowSettings, content: {
            SettingsView(difficulty: $selectedGameDifficulty, timerIsOn: $isTimerOn, onClose: {
                isShowSettings.toggle()
            })
            .presentationDetents([.height(300)])
        })
    }
    
    private func restartGame() {
        isGameFinished = false
        timer?.invalidate()
        timer = nil
        tapsNumber = 0
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
                self.isGameFinished = true
            }
        }
    }
}

#Preview {
    FishEaterView()
}
