//
//  TagView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/13/26.
//

import UIKit

import SnapKit
import Then

final class TagView: BaseView {
    
    // MARK: - Properties
    
    enum TagType {
        case primaryWhiteSmall, primaryWhiteLarge
        case primaryGraySmall, primaryGrayLarge
        case secondarySmall, secondaryLarge
        
        var backgroundColor: UIColor {
            switch self {
            case .primaryWhiteSmall, .primaryWhiteLarge, .secondarySmall, .secondaryLarge: return .potiWhite
            case .primaryGraySmall, .primaryGrayLarge: return .gray100
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .secondarySmall, .secondaryLarge: return .sementicRed
            default: return .poti600
            }
        }
        
        var font: UIFont {
            switch self {
            case .primaryWhiteSmall, .primaryGraySmall, .secondaryLarge: return PotiFontManager.caption12m.font
            case .primaryWhiteLarge, .primaryGrayLarge: return PotiFontManager.body14m.font
            case .secondarySmall: return PotiFontManager.caption10m.font
            }
        }
        
        private var isLarge: Bool {
            return String(describing: self).contains("Large")
        }
    }
    
    private var type: TagType
    
    // MARK: - UI Component
    
    private var tagTextLabel = UILabel()
    
    // MARK: - Initializer
    
    init(type: TagType, tagText: String) {
        self.type = type
        super.init(frame: .zero)
        
        tagTextLabel.text = tagText
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        self.clipsToBounds = true
        self.backgroundColor = type.backgroundColor
        
        tagTextLabel.do {
            $0.textColor = type.textColor
            $0.font = type.font
        }
    }
    
    override func setUI() {
        self.addSubview(tagTextLabel)
    }
    
    override func setLayout() {
        tagTextLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.verticalEdges.equalToSuperview().inset(4)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    // MARK: - Public Method
    
    func setTagText(_ text: String) {
        tagTextLabel.text = text
    }
}
