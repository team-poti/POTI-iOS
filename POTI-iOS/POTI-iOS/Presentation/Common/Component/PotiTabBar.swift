//
//  PotiTabBar.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

class PotiTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        appearance()
    }
    
    func setTabBar() {
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        vc1.tabBarItem = UITabBarItem(title: "홈", image: .icnHome, tag: 1)
        let vc2 = UINavigationController(rootViewController: LoginViewController())
        vc2.tabBarItem = UITabBarItem(title: "분철 내역", image: .icnHistory, tag: 2)
        let vc3 = UINavigationController(rootViewController: LoginViewController())
        vc3.tabBarItem = UITabBarItem(title: "마이페이지", image: .icnMypage, tag: 3)
        self.viewControllers = [vc1, vc2, vc3]
    }
    
    func appearance() {
        let barAppearance = UITabBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        
        barAppearance.stackedLayoutAppearance.normal.iconColor = .gray700
        
        self.tabBar.tintColor = .poti600
        self.tabBar.backgroundColor = .potiWhite
        
        self.tabBar.layer.borderColor = UIColor.gray300.cgColor
        self.tabBar.layer.borderWidth = 1
        
        barAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont(name: "Pretendard-Medium", size: 12)!,
            .foregroundColor: UIColor.gray700
        ]

        barAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont(name: "Pretendard-Medium", size: 12)!,
            .foregroundColor: UIColor.poti600
        ]
        
        barAppearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: .dynamicH(-12))
        barAppearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: .dynamicH(-12))
        
        self.tabBar.standardAppearance = barAppearance
        
        self.tabBar.layer.cornerRadius = 20
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.layer.masksToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = tabBar.frame
        tabFrame.size.height = .dynamicH(114)
        tabFrame.origin.y = view.frame.size.height - .dynamicH(114)
        tabBar.frame = tabFrame
    }
}
