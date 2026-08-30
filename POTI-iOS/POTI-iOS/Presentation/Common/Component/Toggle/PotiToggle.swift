//
//  PotiToggle.swift
//  POTI-iOS
//
//  Created by soomin on 8/27/26.
//

import UIKit

import SnapKit
import Then

final class PotiToggle: UIControl {

    // MARK: - Properties

    private(set) var isOn = false
    private var thumbLeadingConstraint: Constraint?

    // MARK: - UI Components

    private let trackView = UIView()
    private let thumbView = UIView()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        updateStyle()
        addTarget(self, action: #selector(toggleTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func setStyle() {
        isAccessibilityElement = true
        accessibilityTraits = .button

        trackView.layer.cornerRadius = 13
        trackView.isUserInteractionEnabled = false

        thumbView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 10
            $0.isUserInteractionEnabled = false
        }
    }

    private func setUI() {
        addSubview(trackView)
        trackView.addSubview(thumbView)
    }

    private func setLayout() {
        snp.makeConstraints {
            $0.size.equalTo(46)
        }

        trackView.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(46)
            $0.height.equalTo(26)
        }

        thumbView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
            thumbLeadingConstraint = $0.leading.equalToSuperview().offset(3).constraint
        }
    }

    private func updateStyle() {
        trackView.backgroundColor = isOn ? .poti600 : .gray500
        thumbLeadingConstraint?.update(offset: isOn ? 23 : 3)
        accessibilityValue = isOn ? "켬" : "끔"
    }
    
    // MARK: - Public Method

    func setOn(_ isOn: Bool, animated: Bool) {
        guard self.isOn != isOn else { return }
        self.isOn = isOn
        updateStyle()

        guard animated else {
            layoutIfNeeded()
            return
        }

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Action

    @objc private func toggleTapped() {
        setOn(!isOn, animated: true)
        sendActions(for: .valueChanged)
    }
}
