//
//  SearchListCell.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import SnapKit
import Then

final class SearchListCell: UITableViewCell {
    
    // MARK: - Property
    
    static let identifier = String(describing: SearchListCell.self)
    
    // MARK: - UI Component
    
    private let titleLabel = UILabel()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Private Methods
    
    private func setStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        
        titleLabel.do {
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
        }
    }
    
    private func setUI() {
        contentView.addSubview(titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Public Method
    
    func configure(with text: String) {
        titleLabel.setLabel(text, font: .body14m, color: .potiBlack)
    }
}
