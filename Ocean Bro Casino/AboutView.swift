//
//  AboutView.swift
//  Ocean Bro Casino
//
//  Created by DeveloperMB2020 on 10.09.2024.
//

import SwiftUI

struct AboutView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Text("About App")
                    .font(.title.bold())
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }
            .overlay(alignment: .trailing) {
                Button {
                    AppFeedbackGenerator.occureImpact(with: .light)

                    isPresented = false
                } label: {
                    ZStack {
                        Image.appSmallCloseIcon
                            .resizable()
                            .frame(width: 36, height: 36)
                    }
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                }
            }
            .padding(.top, 24)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy for Ocean Bro Casino")
                        .font(.title)
                        .bold()
                    
                    Text("Last updated: 10.09.2024")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("""
                        At Ocean Bro Casino, we are committed to protecting your privacy. This Privacy Policy outlines the type of information we *do not* collect, how we handle your data (or lack thereof), and our commitment to safeguarding your privacy when using the app.
                        
                        **1. Information Collection**
                        Ocean Bro Casino does not collect, store, or process any personal or sensitive information from users. This includes, but is not limited to:
                        - Names
                        - Email addresses
                        - Phone numbers
                        - Payment information
                        - Location data
                        - Device data
                        - Game activity or user behavior
                        
                        We do not use any tracking tools such as cookies, analytics, or third-party services to collect data.
                        
                        **2. No User Accounts or Logins**
                        Ocean Bro Casino operates without requiring users to register an account, log in, or provide any personal information. You can enjoy our games anonymously.
                        
                        **3. Third-Party Services**
                        We do not use any third-party services, advertising networks, or analytics tools that could collect data on your usage of the app.
                        
                        **4. Data Security**
                        Since we do not collect any information, there are no security concerns regarding personal data storage. However, we are committed to providing a safe and enjoyable gaming environment, and we regularly review our app to ensure that it remains free from vulnerabilities.
                        
                        **5. Children’s Privacy**
                        Ocean Bro Casino is intended for users aged 18 and older. We do not knowingly collect information from children, as no data collection occurs within the app.
                        
                        **6. Changes to This Privacy Policy**
                        We may update our Privacy Policy from time to time. Any changes will be reflected on this page with an updated date. Since we do not collect user data, there will be no direct notifications of changes.
                        
                        **7. Contact Us**
                        If you have any questions or concerns about this Privacy Policy, feel free to contact us at:
                        Email: vyacheslav.ts@affstellar.com
                        
                        ---
                        
                        By using Ocean Bro Casino, you confirm that you understand and agree to this Privacy Policy.
                        """)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    AboutView(isPresented: .constant(true))
}
