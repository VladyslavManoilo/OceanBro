//
//  ButtonStyles.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 09.09.2024.
//

import SwiftUI

struct AppPrimaryButtonStyle: ButtonStyle {
    var padding: CGFloat = 50
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding(padding)
            .foregroundStyle(.appButtonText)
            .background(Circle().fill(.appButtonBackground))
            .font(.title.bold())
            .contentShape(Circle())
            .overlay {
                Circle()
                    .inset(by: -padding/5)
                    .stroke(.appBorder, lineWidth: padding / 5)
            }
            
    }
}

struct AppSecondaryButtonStyle: ButtonStyle {
    var padding: CGFloat = 50
    
    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .padding(padding)
            .frame(maxWidth: .infinity)
            .foregroundStyle(.appButtonText)
            .background(RoundedRectangle(cornerRadius: padding/8).fill(.appButtonBackground))
            .font(.title.bold())
            .contentShape(RoundedRectangle(cornerRadius: padding/8))
            .overlay {
                RoundedRectangle(cornerRadius: padding/8)
                    .inset(by: -padding/5)
                    .stroke(.appBorder, lineWidth: padding / 5)
            }
            
    }
}


