//
//  JoinPotInfoCell.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/19/26.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class JoinPotInfoCell: UITableViewCell {
    
    var onTapPotButton: (() -> Void)?
    
    // MARK: - UI Component
    
    private let potIdLabel = UILabel()
    private let thumbnailView = UIImageView()
    private let artistLabel = UILabel()
    private let potTitleLabel = UILabel()
    private let potStatusLabel = UILabel()
    private let potButton = UIButton()
    
    // MARK: - Lifecycle
    
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
    
    // MARK: - Custom Method
    
    private func setStyle() {
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
        }
        
        potButton.do {
            $0.setImage(UIImage(resource: .icnArrowRightLg).withTintColor(.gray700), for: .normal)
        }
    }
    
    private func setUI() {
        
        contentView.addSubviews(
            potStatusLabel,
            potTitleLabel,
            artistLabel,
            thumbnailView,
            potIdLabel,
            potButton
        )
    }
    
    private func setLayout() {
        
        potIdLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
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
        potButton.addTarget(
            self,
            action: #selector(potButtonTapped(_:)),
            for: .touchUpInside
        )
    }
    
    // MARK: - action
    
    @objc func potButtonTapped(_ sender: Any) {
        print("potButtonTapped")
        onTapPotButton?()
    }
    
    /// 0121 어떻게 재사용할 수 있을지 고민.. (PotInfoCell 이랑 JoinInfoCell)
    func configure(model: MyPageJoinModel) {
        potIdLabel.text = "참여 번호 poti-" + String(model.participationId)
        
        if let url = URL(string: model.imageUrlString) {
            thumbnailView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder")
            )
        } else {
            thumbnailView.image = UIImage(named: "placeholder")
        }
        
        artistLabel.text = model.artistName
        potTitleLabel.text = model.title
        potStatusLabel.text = model.postStatus.potStatusText
        potStatusLabel.textColor = model.postStatus.potStatusColor
    }
}
