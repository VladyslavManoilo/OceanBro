//
//  GamesListView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import SwiftUI

struct GamesListView: View {
    @State private var isAboutViewShown: Bool = false

    let games = GameType.allCases
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        Text("Games")
                            .frame(maxWidth: .infinity)
                            .font(.largeTitle.bold())
                            .foregroundStyle(.appText)
                            .shadow(color: .black, radius: 1)
                            .padding(.top, 60)
                    }
                    .overlay(alignment: .topTrailing, content: {
                        Button {
                            AppFeedbackGenerator.occureImpact(with: .light)

                            isAboutViewShown.toggle()
                        } label: {
                            Image.appAboutIcon
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        }
                        .buttonStyle(AppPrimaryButtonStyle(padding: 12))
                        .padding(.top, 60)
                        .padding(.horizontal, 16)
                    })
                    
                    ScrollView {
                        ZStack {
                            VStack {
                                let size = calculatedPreviewSize(with: geometry.size)
                                ForEach(games) { game in
                                    NavigationLink {
                                        switch game {
                                        case .threeInRow:
                                            ThreeInRowGameView()
                                        case .findTreasure:
                                            FindTreasureView()
                                        case .fishEater:
                                            FishEaterView()
                                        }
                                    } label: {
                                        ZStack {
                                            VStack {
                                                game.previewImage
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(height: size.height/1.5)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    .padding(.horizontal, 16)
                                                    .padding(.top, size.width/10)
                                                    .layoutPriority(-1)
                                                
                                                Spacer()
                                                
                                                Text(game.title)
                                                    .foregroundStyle(.appText)
                                                    .font(.title.bold())
                                                    .padding(.horizontal, 16)
                                                    .padding(.bottom, size.width/10)
                                            }
                                        }
                                        .frame(width: size.width, height: size.height)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.black.opacity(0.5))
                                        }
                                    }
                                }
                            }
                            .padding(.bottom, 120)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
            }
        }
        .ignoresSafeArea()
        .background {
            Image(.backgroundForGames)
                .resizable()
                .scaledToFill()
                .layoutPriority(-1)
                .ignoresSafeArea()
                .overlay(.black.opacity(0.05))

        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $isAboutViewShown, content: {
            AboutView(isPresented: $isAboutViewShown)
        })
    }
    
    private func calculatedPreviewSize(with geometry: CGSize) -> CGSize {
        let padding: CGFloat = 32
        var width = geometry.width - padding
        if width <= 0 {
            width = 1
        }
        let height = width
        return CGSize(width: width, height: height)
    }
}

#Preview {
    GamesListView()
}
