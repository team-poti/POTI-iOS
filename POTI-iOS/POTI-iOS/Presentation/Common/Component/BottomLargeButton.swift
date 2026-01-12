//
//  BottomLargeButton.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

import SnapKit

public final class BottomLargeButton: UIButton, PotiButtonProtocol {
    
    public var color: ColorType = .primaryMain
    
    public var buttonSize: CGFloat = .dynamicH(52)
    
    private var heightConstraint: Constraint?
        
    public var cornerRadius: CGFloat = .dynamicH(26) {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    /// isDisabled = true이면 버튼 비활성화
    public var isDisabled: Bool = false {
        didSet {
            isUserInteractionEnabled = !isDisabled
        }
    }
    
    public var text: String? {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    
    
    // MARK: - Init
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    
    private func setup() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        titleLabel?.font = PotiFontManager.button16sb.font
        setTitle(text, for: .normal)
        setTitleColor(color.titleColor, for: .normal)
        setLayout()
    }
    
    
    // MARK: - SetLayout
    
    private func setLayout() {
        self.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(buttonSize).constraint
            $0.width.equalToSuperview().inset(16)
        }
    }
    
    public override var isHighlighted: Bool {
        didSet {
            guard !isDisabled else { return }

            if isHighlighted {
                backgroundColor = color.pressedBackgroundColor
            } else {
                backgroundColor = color.defaultBackgroundColor
            }
        }
    }
}
