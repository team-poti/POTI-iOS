//
//  PotInfoCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/13/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PotInfoCell: UITableViewCell {

    var onTapPotButton: (() -> Void)?
    
    // MARK: - UI Component
    
    private let potIdLabel = UILabel()
    private let thumbnailView = UIImageView()
    private let artistLabel = UILabel()
    private let potTitleLabel = UILabel()
    private let potStatusLabel = UILabel()
    private let potButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .potiWhite
        
        setUI()
        setStyle()
        setLayout()
        addTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        contentView.backgroundColor = .potiWhite

        potIdLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }

        thumbnailView.do {
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
        }

        artistLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .gray800
        }

        potTitleLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.numberOfLines = 2
        }

        potStatusLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .sementicRed
        }

        potButton.do {
            $0.setImage(.icnArrowRightLg, for: .normal)
        }
    }
    
    func setUI() {
        contentView.addSubviews(
            potStatusLabel,
            potTitleLabel,
            artistLabel,
            thumbnailView,
            potIdLabel,
            potButton
        )
    }
    
    func setLayout() {
        potIdLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
        }
        
        thumbnailView.snp.makeConstraints {
            $0.top.equalTo(potIdLabel.snp.bottom).offset(12)
            $0.leading.equalTo(potIdLabel)
            $0.width.height.equalTo(96)
        }
        
        potButton.snp.makeConstraints {
            $0.centerY.equalTo(thumbnailView)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(24)
        }
        
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailView).inset(4)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(12)
        }
        
        potTitleLabel.snp.makeConstraints {
            $0.top.equalTo(artistLabel.snp.bottom)
            $0.horizontalEdges.equalTo(artistLabel)
        }
        
        potStatusLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(potTitleLabel)
            $0.bottom.equalTo(thumbnailView).inset(4)
        }
    }
    
    private func addTarget() {
        potButton.addTarget(self, action: #selector(potButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - action
    @objc func potButtonTapped(_ sender: Any) {
        onTapPotButton?()
    }
    
    func configure(model: PotInfoViewState) {
        potIdLabel.text = "모집번호 poti-\(model.postId)"

        if let url = URL(string: model.imageUrl) {
            thumbnailView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder")
            )
        } else {
            thumbnailView.image = UIImage(named: "placeholder")
        }

        artistLabel.text = model.artistName
        potTitleLabel.text = model.title
        potStatusLabel.text = model.status.badgeText
        potStatusLabel.textColor = model.status.badgeColor
    }
}
