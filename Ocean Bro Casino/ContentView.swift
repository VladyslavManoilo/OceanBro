//
//  ContentView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isAboutViewShown: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    VStack(spacing: 10) {
                        HStack {
                            Image.appFishIcon
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.appText)
                                .scaledToFit()
                                .frame(width: 50)
                            
                            Spacer()
                            
                            Image.appFishIcon
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.appText)
                                .scaledToFit()
                                .frame(width: 50)
                        }
                        .padding(.horizontal, 50)
                        
                        Text("Ocean Bro Casino")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.appText)
                            .shadow(radius: 5)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.appButtonBackground, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round, dash: [1, 7], dashPhase: 0))
                                    .shadow(radius: 5)
                                
                            }
                        
                        Image.appFishIcon
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.appText)
                            .scaledToFit()
                            .frame(width: 50)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Image(.background)
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 10)
                        .layoutPriority(-1)
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
                .overlay(alignment: .bottom, content: {
                    NavigationLink {
                        GamesListView()
                    } label: {
                        Text("Start")
                    }
                    .buttonStyle(AppPrimaryButtonStyle())
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120)
                })
                .ignoresSafeArea()
            }
        }
        .sheet(isPresented: $isAboutViewShown, content: {
            AboutView(isPresented: $isAboutViewShown)
        })
    }
}

#Preview {
    ContentView()
}
