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
    
    private let mockJoinPotInfoModel: JoinPotInfoModel = JoinPotInfoModel(
        potId: 1110,
        thumbnail: "https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F311%2F2025%2F08%2F18%2F0001905912_001_20250818141307379.jpg&type=a340",
        artistName: "코르티스",
        potTitle: "코르티스 포티팟",
        status: .recruiting
    )
    
    var onTapPotButton: (() -> Void)? // TODO: - input output 패턴 넣기
    
    
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
    
    func setStyle() {
        potIdLabel.do {
            $0.setLabel(
                "모집 번호 poti-" + String(mockJoinPotInfoModel.potId),
                font: .body14m
            )
            $0.textColor = .gray800
        }
        
        thumbnailView.do {
            let url = URL(string: mockJoinPotInfoModel.thumbnail)
            $0.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder")
            )
            $0.clipsToBounds = true
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
        }
        
        artistLabel.do {
            $0.setLabel(
                mockJoinPotInfoModel.artistName,
                font: .body14m
            )
            $0.textColor = .gray800
        }
        
        potTitleLabel.do {
            $0.setLabel(
                mockJoinPotInfoModel.potTitle,
                font: .body16m
            )
            $0.textColor = .potiBlack
        }
        
        potStatusLabel.do {
            $0.setLabel(
                mockJoinPotInfoModel.status.potStatusText,
                font: .body14sb
            )
            $0.textColor = .sementicRed
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
        
        //TODO: - input 수정 -> VM 로 추후에 옮기자
        
        // input.send(.potButtonTapped)
    }
}
