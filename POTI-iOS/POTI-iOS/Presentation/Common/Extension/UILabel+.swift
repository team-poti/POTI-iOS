//
//  UILabel+.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/12/26.
//

import UIKit

public extension UILabel {

    func setLabel(
        _ text: String,
        font style: PotiFontManager,
        alignment: NSTextAlignment = .natural,
        color: UIColor = .label
    ) {
        let property = style.fontProperty

        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = property.lineHeight
        paragraph.maximumLineHeight = property.lineHeight
        paragraph.alignment = alignment

        let font = UIFont(
            name: property.font.name,
            size: property.size
        ) ?? UIFont.systemFont(ofSize: property.size)

        self.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .paragraphStyle: paragraph,
                .foregroundColor: color
            ]
        )
    }
}
