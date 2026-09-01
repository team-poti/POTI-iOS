//
//  UILabel+.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/12/26.
//

import UIKit

public extension UILabel {

    // MARK: - Public Methods

    func setLabel(_ text: String, font style: PotiFontManager, alignment: NSTextAlignment = .natural, color: UIColor = .label) {
        let property = style.fontProperty

        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = property.lineHeight
        paragraph.maximumLineHeight = property.lineHeight
        paragraph.alignment = alignment

        let font = UIFont(name: property.font.name, size: property.size) ?? UIFont.systemFont(ofSize: property.size)

        attributedText = NSAttributedString(string: text, attributes: [.font: font, .paragraphStyle: paragraph, .foregroundColor: color])
    }

    func setLabel(_ text: NSAttributedString, lineHeight style: PotiFontManager, alignment: NSTextAlignment = .natural) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = style.fontProperty.lineHeight
        paragraph.maximumLineHeight = style.fontProperty.lineHeight
        paragraph.alignment = alignment

        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.addAttribute(.paragraphStyle, value: paragraph, range: NSRange(location: 0, length: mutableText.length))
        attributedText = mutableText
    }

    func setText(_ text: String, lineSpacing: CGFloat, alignment: NSTextAlignment = .natural) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        attributedText = NSAttributedString(string: text, attributes: [.paragraphStyle: paragraphStyle])
    }
}
