//
//  PostViewModel.swift
//  ARBrush
//
//  Created by teresa liang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        posts.append(Post(id: 1, imageName: "venom-4"))
        posts.append(Post(id: 2, imageName: "venom-10"))
        posts.append(Post(id: 3, imageName: "venom-3"))
        posts.append(Post(id: 4, imageName: "venom-7"))
        posts.append(Post(id: 5, imageName: "venom-7"))
        posts.append(Post(id: 6, imageName: "venom-7"))
        posts.append(Post(id: 7, imageName: "venom-2"))
        posts.append(Post(id: 8, imageName: "venom-1"))
    }
}
