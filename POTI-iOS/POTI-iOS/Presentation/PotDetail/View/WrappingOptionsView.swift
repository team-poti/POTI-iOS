//
//  WrappingOptionsView.swift
//  POTI-iOS
//
//  Created by soomin on 9/2/26.
//

import UIKit

import SnapKit
import Then

final class WrappingOptionsView: UIView {
    private enum Layout {
        static let itemHeight: CGFloat = 21
        static let horizontalSpacing: CGFloat = 10
        static let dividerWidth: CGFloat = 1
        static let rowSpacing: CGFloat = 8
    }
    
    // MARK: - Properties

    private let labels: [UILabel]
    private let dividers: [UIView]
    private var measuredHeight = Layout.itemHeight
    private var previousWidth: CGFloat = 0
    private var heightConstraint: Constraint?
    
    // MARK: - Initializer

    init(values: [String]) {
        labels = values.map { value in
            UILabel().then {
                $0.font = PotiFontManager.body14m.font
                $0.textColor = .potiBlack
                $0.text = value
                $0.numberOfLines = 1
            }
        }
        dividers = values.dropFirst().map { _ in
            UIView().then {
                $0.backgroundColor = .gray800
            }
        }

        super.init(frame: .zero)
        labels.forEach(addSubview)
        dividers.forEach(addSubview)
        snp.makeConstraints {
            heightConstraint = $0.height.equalTo(Layout.itemHeight).constraint
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: measuredHeight)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard bounds.width > 0 else { return }
        let newHeight = layoutItems(availableWidth: bounds.width, applyFrames: true)

        if previousWidth != bounds.width || measuredHeight != newHeight {
            previousWidth = bounds.width
            measuredHeight = newHeight
            heightConstraint?.update(offset: newHeight)
            invalidateIntrinsicContentSize()
            superview?.invalidateIntrinsicContentSize()
            superview?.setNeedsLayout()
        }
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let width = targetSize.width > 0 ? targetSize.width : bounds.width
        return CGSize(width: width, height: layoutItems(availableWidth: width, applyFrames: false))
    }

    private func layoutItems(availableWidth: CGFloat, applyFrames: Bool) -> CGFloat {
        guard !labels.isEmpty else { return 0 }

        var x: CGFloat = 0
        var y: CGFloat = 0

        for (index, label) in labels.enumerated() {
            let labelWidth = min(ceil(label.intrinsicContentSize.width), availableWidth)
            let separatorWidth = Layout.horizontalSpacing + Layout.dividerWidth + Layout.horizontalSpacing
            let requiredWidth = index == 0 || x == 0 ? labelWidth : separatorWidth + labelWidth
            let shouldWrap = x > 0 && x + requiredWidth > availableWidth

            if shouldWrap {
                x = 0
                y += Layout.itemHeight + Layout.rowSpacing
            }

            if index > 0 {
                let divider = dividers[index - 1]
                divider.isHidden = x == 0

                if x > 0 {
                    x += Layout.horizontalSpacing
                    if applyFrames {
                        divider.frame = CGRect(x: x, y: y, width: Layout.dividerWidth, height: Layout.itemHeight)
                    }
                    x += Layout.dividerWidth + Layout.horizontalSpacing
                }
            }

            if applyFrames {
                label.frame = CGRect(x: x, y: y, width: labelWidth, height: Layout.itemHeight)
            }
            x += labelWidth
        }

        return y + Layout.itemHeight
    }
}
