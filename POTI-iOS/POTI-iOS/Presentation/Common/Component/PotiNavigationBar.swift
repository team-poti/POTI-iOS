//
//  PotiNavigationBar.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

import SnapKit

public enum PotiNavigationStyle {
    case home
    case mypage
    case xButton
    case backDefault(String)
    case backSubtitle(title: String, subtitle: String)
    case backWithButton(title: String)
}

public enum PotiNavigationAction: Int {
    case back
    case xButton
    case search
    case alarm
    case setting
    case change
}

struct PotiNavigationBar {
    
    static func configure(
        navigationItem: UINavigationItem,
        navigationController: UINavigationController?,
        style: PotiNavigationStyle,
        target: (UIViewController & NavigationActionHandling)
    ) {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.titleView = nil
        
        switch style {
        case .home:
            navigationItem.leftBarButtonItem = makeHomeLogoTitleView()
            navigationItem.rightBarButtonItems = [
                makeIconButton(image: .icnAlarm, action: .alarm, target: target),
                makeIconButton(image: .icnSearch, action: .search, target: target)
            ]
            
        case .mypage:
            navigationItem.leftBarButtonItem = makeMypageTitleLabel()
            navigationItem.rightBarButtonItems = [
                makeIconButton(image: .icnAlarm, action: .alarm, target: target),
                makeIconButton(image: .icnSetting, action: .setting, target: target)
            ]
            
        case .xButton:
            navigationItem.leftBarButtonItem = makeIconButton(image: .icnX, action: .xButton, target: target)
            
        case .backDefault(let title):
            navigationItem.titleView = makeTitleLabel(title)
            navigationItem.leftBarButtonItem = makeIconButton(image: .icnArrowLeftLg, action: .back, target: target)
            
        case .backSubtitle(title: let title, subtitle: let subtitle):
            navigationItem.titleView = makeTitleSubtitleView(title: title, subtitle: subtitle)
            navigationItem.leftBarButtonItem = makeIconButton(image: .icnArrowLeftLg, action: .back, target: target)
            
        case .backWithButton(title: let title):
            navigationItem.titleView = makeTitleLabel(title)
            navigationItem.leftBarButtonItem = makeIconButton(image: .icnArrowLeftLg, action: .back, target: target)
            navigationItem.rightBarButtonItem = makeIconButton(image: .icnSwtich, action: .change, target: target)
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .potiWhite
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension PotiNavigationBar {
    
    // MARK: - Logo
    
    private static func makeHomeLogoTitleView() -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(.logo.withRenderingMode(.alwaysOriginal), for: .normal)
        button.isUserInteractionEnabled = false
        button.imageView?.contentMode = .scaleAspectFit
        return UIBarButtonItem(customView: button)
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
    
    private static func makeTitleSubtitleView(title: String, subtitle: String) -> UIView {
        
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
    
    private static func makeMypageTitleLabel() -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setTitle("마이", for: .normal)
        button.titleLabel?.font = PotiFontManager.title18sb.font
        button.tintColor = .potiBlack
        button.isUserInteractionEnabled = false
        
        return UIBarButtonItem(customView: button)
    }
    
    // MARK: - Button
    
    private static func makeIconButton(image: UIImage?, action: PotiNavigationAction, target: (UIViewController & NavigationActionHandling)) -> UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = action.rawValue
        button.addTarget(target, action: #selector(BaseViewController<Any>.navigationButtonTapped(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
}
