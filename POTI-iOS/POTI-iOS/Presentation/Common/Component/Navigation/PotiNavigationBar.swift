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
    case backButton
    case backDefault(String)
    case backSubtitle(title: String, subtitle: String)
    case backWithButton(title: String)
    case notification
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
    private enum IconAlignment {
        case leading
        case trailing
    }
    
    private enum Spacing {
        static let leftLogo: CGFloat = 12
        static let rightButton: CGFloat = 12
        static let leftTitle: CGFloat = 12
    }
    
    @MainActor
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
            navigationItem.leftBarButtonItems = [makeFixedSpace(Spacing.leftLogo), makeHomeLogoTitleView()]
            
            let searchButton = makeIconButtonView(image: .icnSearch, action: .search, target: target)
            let alarmButton = makeIconButtonView(image: .icnAlarm, action: .alarm, target: target)
                
            navigationItem.rightBarButtonItem = makeButtonGroupWithPadding(buttons: [searchButton, alarmButton],
                                                                           spacing: 0, rightPadding: Spacing.rightButton)
            
        case .mypage:
            navigationItem.leftBarButtonItems = [makeFixedSpace(Spacing.leftTitle), makeMypageTitleLabel()]
            
            let settingButton = makeIconButtonView(image: .icnSetting, action: .setting, target: target)
            let alarmButton = makeIconButtonView(image: .icnAlarm, action: .alarm, target: target)
                
            navigationItem.rightBarButtonItem = makeButtonGroupWithPadding(buttons: [settingButton, alarmButton],
                                                                           spacing: 0, rightPadding: Spacing.rightButton)
            
        case .xButton:
            navigationItem.leftBarButtonItem = makeAlignedIconButton(image: .icnX, action: .xButton,
                                                                     target: target, alignment: .leading)
            
        case .backButton:
            navigationItem.leftBarButtonItem = makeAlignedIconButton(image: .icnArrowLeftLg, action: .back,
                                                                     target: target, alignment: .leading)
            
        case .backDefault(let title):
            navigationItem.titleView = makeTitleLabel(title)
            navigationItem.leftBarButtonItem = makeAlignedIconButton(image: .icnArrowLeftLg, action: .back,
                                                                     target: target, alignment: .leading)
            
        case .backSubtitle(title: let title, subtitle: let subtitle):
            navigationItem.titleView = makeTitleSubtitleView(title: title, subtitle: subtitle)
            navigationItem.leftBarButtonItem = makeAlignedIconButton(image: .icnArrowLeftLg, action: .back,
                                                                     target: target, alignment: .leading)
            
        case .backWithButton(title: let title):
            navigationItem.titleView = makeTitleLabel(title)
            navigationItem.leftBarButtonItem = makeAlignedIconButton(image: .icnArrowLeftLg, action: .back,
                                                                     target: target, alignment: .leading)
            navigationItem.rightBarButtonItem = makeAlignedIconButton(image: .icnSwtich,action: .change,
                                                                      target: target, alignment: .trailing)

        case .notification:
            navigationItem.titleView = makeTitleLabel("알림")
            navigationItem.leftBarButtonItem = makeAlignedIconButton(image: .icnArrowLeftLg, action: .back,
                                                                     target: target, alignment: .leading)
            navigationItem.rightBarButtonItem = makeAlignedIconButton(image: .icnSetting, action: .setting,
                                                                      target: target, alignment: .trailing)
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = target.view.backgroundColor
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension PotiNavigationBar {
    
    // MARK: - Helper
    
    private static func makeFixedSpace(_ width: CGFloat) -> UIBarButtonItem {
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = width
        return spacer
    }
    
    private static func makeButtonGroup(buttons: [UIButton], spacing: CGFloat = 0) -> UIBarButtonItem {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return UIBarButtonItem(customView: stackView)
    }
    
    private static func makeButtonGroupWithPadding(buttons: [UIButton], spacing: CGFloat = 0, rightPadding: CGFloat = 0) -> UIBarButtonItem {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        let containerView = UIView()
        containerView.clipsToBounds = false
        containerView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(rightPadding)
            $0.trailing.equalToSuperview().offset(rightPadding)
        }
        
        return UIBarButtonItem(customView: containerView)
    }
    
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
    
    private static func makeIconButtonView(image: UIImage?, action: PotiNavigationAction, target: (UIViewController & NavigationActionHandling)) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = action.rawValue
        button.addTarget(target, action: #selector(NavigationActionHandling.navigationButtonTapped(_:)), for: .touchUpInside)
        
        button.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(44)
        }
        
        return button
    }
    
    private static func makeAlignedIconButton(image: UIImage?, action: PotiNavigationAction, target: (UIViewController & NavigationActionHandling), alignment: IconAlignment) -> UIBarButtonItem {
        let containerView = UIView()
        let imageView = UIImageView(image: image?.withRenderingMode(.alwaysOriginal))
        let button = UIButton(type: .system)

        imageView.contentMode = .scaleAspectFit
        button.tag = action.rawValue
        button.addTarget(target, action: #selector(NavigationActionHandling.navigationButtonTapped(_:)), for: .touchUpInside)

        containerView.addSubviews(imageView, button)
        containerView.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(44)
        }
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)

            if alignment == .leading {
                $0.leading.equalToSuperview().offset(-12)
            } else {
                $0.trailing.equalToSuperview().offset(12)
            }
        }
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        return UIBarButtonItem(customView: containerView)
    }
}
