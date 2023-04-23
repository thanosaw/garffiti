//
//  ProfileViewController.swift
//  ARBrush
//
//  Created by Andrew Wang on 4/22/23.
//  Copyright © 2023 Laan Labs. All rights reserved.
//

import UIKit
import SwiftUI

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let vc = UIHostingController(rootView: ContentView())
        let contentView = vc.view!
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addChildViewController(vc)
        
        view.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// Profile View Controller
//final class ProfileViewController: UIViewController {
//
//    private var collectionView: UICollectionView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//
//        // Do any additional setup after loading the view.
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: view.bounds.width/3, height: view.bounds.width / 3)
//
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        guard let collectionView = collectionView else {
//            return
//        }
//        view.addSubview(collectionView)
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        collectionView?.frame = view.bounds
//    }
//}
//
//extension ProfileViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return 0
//        }
//
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            return UICollectionViewCell()
//        }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//    }
//
//    }


