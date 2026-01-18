//
//  PotiNavigationController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

final class PotiNavigationController: UINavigationController {
    
    private let customNavBarHeight: CGFloat = 56
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var newFrame = navigationBar.frame
        newFrame.size.height = customNavBarHeight
        navigationBar.frame = newFrame
    }
}
