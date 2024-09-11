//
//  FindTreasureView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI
import SpriteKit

extension GameDifficulty {
    var numberOfChests: Int {
        switch self {
        case .easy:
            return 2
        case .hard:
            return 3
        }
    }
    
    var shuffleSpeed: Double {
        switch self {
        case .easy:
            return 1.5
        case .hard:
            return 0.5
        }
    }
    
    var timerDuration: Int {
        switch self {
        case .easy:
            return 60
        case .hard:
            return 30
        }
    }
}

// MARK: - SwiftUI Game View
struct FindTreasureView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    private let settingsTimerUDKey = "settingsFindTreasureTimerUDKey"
    
    @State private var isPlaying: Bool = false
    @State private var isOnPause: Bool = false
    @State private var isShowSettings: Bool = false
    
    @State private var timer: Timer?
    @State private var timeRemaining: Int
    @State private var isGameFinished: Bool = false
    @State private var isTimerOn: Bool
    @State private var difficulty: GameDifficulty
    @State private var correctFinds: Int = 0
    
    @State private var isShowCorrectResult: Bool = false
    @State private var isShowIncorrectResult: Bool = false
    
    func scene(size: CGSize) -> TreasureChestScene {
        let scene = TreasureChestScene(correctFinds: $correctFinds, size: size)
        scene.selectedDifficulty = difficulty
        scene.answerSelected = { isCorrect in
            if isShowIncorrectResult, isCorrect {
                isShowIncorrectResult = false
            }

            withAnimation {
                isShowCorrectResult = isCorrect
                isShowIncorrectResult = !isCorrect
            }
        }
        return scene
    }
    
    init() {
        let initialDifficulty: GameDifficulty = .easy
        _difficulty = State(initialValue: initialDifficulty)
        _isTimerOn = State(initialValue: (UserDefaults.standard.value(forKey: settingsTimerUDKey) as? Bool) ?? true)
        _timeRemaining = State(initialValue: initialDifficulty.timerDuration)
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack {
                    if isPlaying {
                        if !isOnPause {
                            let offset: CGFloat = 16
                            let width = geometry.size.width - offset
                            * 2
                            let size = CGSize(width: width, height: width)
                            VStack {
                                if isTimerOn {
                                    Text("Time: \(timeRemaining)")
                                        .font(.largeTitle)
                                        .foregroundStyle(.appText)
                                        .padding()
                                        .shadow(color: .black, radius: 1)
                                }
                                    
                                Text("Strikes: \(correctFinds)")
                                    .font(.title)
                                    .foregroundStyle(.appText)
                                    .padding()
                                    .shadow(color: .black, radius: 1)
                                    
                                ZStack {
                                    SpriteView(scene: scene(size: size), options: [.allowsTransparency])
                                        .frame(width: size.width, height: size.height)
                                }
                                .frame(maxWidth: .infinity)
                                
                                if isShowCorrectResult {
                                    ZStack {
                                        Text("You found the treasure!")
                                            .font(.largeTitle.bold())
                                            .foregroundStyle(.green)
                                            .multilineTextAlignment(.center)
                                            .shadow(color: .black, radius: 10)
                                            .padding()

                                    }
                                    .background {
                                        RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.5))
                                    }
                                    .padding(.horizontal, 30)
                                    .transition(.move(edge: .bottom))
                                    .onAppear {
                                        AppFeedbackGenerator.occureImpact(with: .heavy)
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                            isShowCorrectResult = false
                                        })
                                    }
                                }
                                
                                if isShowIncorrectResult {
                                    ZStack {
                                        Text("Oh no! Chest is empty")
                                            .font(.largeTitle.bold())
                                            .foregroundStyle(.red)
                                            .multilineTextAlignment(.center)
                                            .shadow(color: .black, radius: 10)
                                            .padding()
                                    }
                                    .background {
                                        RoundedRectangle(cornerRadius: 12).fill(.black.opacity(0.5))
                                    }
                                    .padding(.horizontal, 30)
                                    .transition(.move(edge: .bottom))
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                            isShowIncorrectResult = false
                                        })
                                    }
                                }
                            }
                            .padding(.top, 50)
                            
                        } else {
                            GamePauseView()
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    isOnPause = false
                                }
                                .ignoresSafeArea()
                        }
                    } else {
                        GameStartView(title: "Find a chest with a treasure") {
                            isPlaying = true
                            startTimer()
                        } onSettngs: {
                            isShowSettings.toggle()}

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
                                    Text("Your Found \(correctFinds) treasures!")
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
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .background {
            Image(.findTreasureBackground)
                .resizable()
                .scaledToFill()
                .layoutPriority(-1)
                .ignoresSafeArea()
                .overlay {
                    Color.black
                        .opacity(0.15)
                        .ignoresSafeArea()
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
        .sheet(isPresented: $isShowSettings, content: {
            SettingsView(difficulty: $difficulty, timerIsOn: $isTimerOn, onClose: {
                isShowSettings.toggle()
            })
            .presentationDetents([.height(300)])
        })
    }
    
    private func restartGame() {
        isGameFinished = false
        timer?.invalidate()
        timer = nil
        timeRemaining = difficulty.timerDuration
        
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
    FindTreasureView()
}
