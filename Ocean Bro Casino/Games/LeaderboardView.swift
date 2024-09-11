//
//  LeaderboardView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI

// Define a Player model
struct Player: Identifiable {
    let id = UUID()
    let nickname: String
    let score: Int
}

struct LeaderboardView: View {
    // Array of Player models
    @State private var leaderboard: [Player] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 36) {
                Text("Leaderboard")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.appText)
                
                ScrollView {
                    LazyVStack {
                        ForEach(leaderboard.indices, id: \.self) { index in
                            HStack {
                                Text("\(index + 1). \(leaderboard[index].nickname)")
                                    .font(.headline)
                                    .foregroundStyle(.appText)
                                
                                Spacer()
                                
                                Text("\(leaderboard[index].score) points")
                                    .font(.subheadline)
                                    .foregroundStyle(.appText)
                                
                            }
                            .padding()
                        }
                    }
                }
                .background(Color(.darkGray))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 16)
        .onAppear {
            shuffleLeaderboard() // Shuffle data when view appears
        }
    }
    
    // Function to shuffle the leaderboard
    func shuffleLeaderboard() {
        // Generate less obvious and more creative nicknames
        let nicknames = [
            "NebulaSurge", "EchoFlare", "QuantumWisp", "IronDune", "VortexShade", "DementorXX", "Rhans", "Mchuck10", "XXXRamilda", "NovaMoon",
            "CrystalHawk", "ZenithPulse", "ShadowTide", "NovaLynx", "CinderMoon"
        ]
        
        // Create leaderboard with random scores and shuffle it
        let leaderboardData = nicknames.map { Player(nickname: $0, score: Int.random(in: 100...1000)) }
        leaderboard = leaderboardData.shuffled()
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}


#Preview {
    LeaderboardView()
}
