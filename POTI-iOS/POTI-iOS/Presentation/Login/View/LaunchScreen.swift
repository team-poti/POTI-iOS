//
//  LaunchScreen.swift
//  POTI-iOS
//
//  Created by neon on 1/14/26.
//

import UIKit

import SnapKit
import Then

public final class LaunchScreen: UIViewController {
    
    private let potiLogoView = UIImageView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .poti600
        
        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        potiLogoView.do {
            $0.image = .imgLottie
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func setUI() {
        view.addSubview(potiLogoView)
    }
    
    private func setLayout() {
        potiLogoView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
