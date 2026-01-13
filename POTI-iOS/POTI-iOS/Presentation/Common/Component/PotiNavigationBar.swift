//
//  PotiNavigationBar.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

import SnapKit

public enum PotiNavigationType {
    case home
    case mypage
    case xButton
    case backDefault(String)
    case backSubtitle(title: String, subtitle: String)
    case backWithButton(title: String, menuIcon: UIImage)
}

struct PotiNavigationBar {

    static func configure(
        navigationItem: UINavigationItem,
        navigationController: UINavigationController?,
        type: PotiNavigationType,
        target: AnyObject
    ) {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = nil
        
        switch type {
        case .home:
            navigationItem.titleView = makeHomeLogoTitleView()
            navigationItem.rightBarButtonItems = [
                makeIconButton(
                    image: .icnSearch,
                    action: .search,
                    target: target
                ),
                makeIconButton(
                    image: .icnAlarm,
                    action: .alarm,
                    target: target
                )
            ]
            
        case .mypage:
            
    }
}

extension PotiNavigationBar {
    
    // MARK: - Logo
    
    private static func makeHomeLogoTitleView() -> UIView {
        let imageView = UIImageView(image: .logo)
        imageView.contentMode = .scaleAspectFit

        // 디자인 기준 사이즈
        imageView.snp.makeConstraints {
            $0.width.equalTo(59)
            $0.height.equalTo(31)
        }

        let container = UIView()
        container.addSubview(imageView)

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        return container
    }
    
    // MARK: - Label
    
    private static func makeTitleLabel(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = PotiFontManager.body16sb.font
        label.textColor = .potiBlack
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }
    
    private static func makeTitleSubtitleView(
        title: String,
        subtitle: String
    ) -> UIView {

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = PotiFontManager.body16sb.font
        titleLabel.textColor = .potiBlack

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = PotiFontManager.caption12m.font
        subtitleLabel.textColor = .gray700

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 2

        return stack
    }
    
    // MARK: - Button
    
    private static func makeIconButton(
        image: UIImage?,
        action: Selector,
        target: AnyObject
    ) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 48, height: 48)
        
        return UIBarButtonItem(customView: button)
    }
}
