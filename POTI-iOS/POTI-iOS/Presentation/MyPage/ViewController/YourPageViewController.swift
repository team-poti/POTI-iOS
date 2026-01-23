//
//  YourPageViewController.swift
//  POTI-iOS
//
//  Created by nayeon on 1/23/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class YourPageViewController: BaseViewController<MyPageViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = YourPageView()
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.viewDidLoad)
    }
}
