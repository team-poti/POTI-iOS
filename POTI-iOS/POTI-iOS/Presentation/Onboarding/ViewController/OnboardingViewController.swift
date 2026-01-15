//
//  OnboardingViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class OnboardingViewController: BaseViewController<Any>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        .backButton
    }
    
    private let rootView = OnboardingDescriptionView()
    
    override func loadView() {
        self.view = rootView
    }
    
}
