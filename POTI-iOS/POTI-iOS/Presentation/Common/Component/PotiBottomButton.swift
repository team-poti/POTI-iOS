//
//  PotiBottomButton.swift
//  POTI-iOS
//
//  Created by neon on 1/13/26.
//

import UIKit

import SnapKit

public final class PotiBottomButton: UIButton, PotiButtonProtocol {
    
    public var color: ColorType = .primaryMain {
        didSet {
            updateColors()
        }
    }
    
    public var buttonSize: CGFloat = .dynamicH(52)
    
    public var size: WidthSize = .large {
        didSet {
            widthConstraint?.update(offset: size.value)
        }
    }
    
    private var heightConstraint: Constraint?
    
    private var widthConstraint: Constraint?
        
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
        setLayout()
        updateColors()
    }
    
    
    // MARK: - SetLayout
    
    private func setLayout() {
        self.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(buttonSize).constraint
            widthConstraint = $0.width.equalTo(size.value).constraint
        }
    }
    
    private func updateColors() {
        setTitleColor(color.titleColor, for: .normal)

        setBackgroundImage(
            .fromUIColor(color: color.defaultBackgroundColor),
            for: .normal
        )

        setBackgroundImage(
            .fromUIColor(color: color.pressedBackgroundColor),
            for: .highlighted
        )
    }
}
