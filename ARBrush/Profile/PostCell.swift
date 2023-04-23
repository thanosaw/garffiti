//
//  PostCell.swift
//  ARBrush
//
//  Created by teresa liang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import Foundation
import SwiftUI

struct PostCell: View {
    let post: Post
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(self.post.imageName)
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
            }
        }
    }
}
