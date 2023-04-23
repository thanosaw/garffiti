//
//  ProfileHeader.swift
//  ARBrush
//
//  Created by teresa liang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfileHeader: View {
    let gradient = Gradient(colors: [.yellow, .orange, .red, .pink, .purple])
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                VStack {
                    Image("person")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.size.width, height: 200)
                        .clipShape(Circle())
                        .clipped()
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.top, 44)
                    
                    Text("Eddie Brock").font(.system(size: 20)).bold().foregroundColor(.white)
                        .padding(.top, 12)
                    
                    Text("@venom").font(.system(size: 18)).foregroundColor(.white)
                    .padding(.top, 4)
                }
                Spacer()
            }
            Spacer()
        }
        .background(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}

