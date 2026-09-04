//
//  NoticeView.swift
//  POTI-iOS
//
//  Created by soomin on 8/4/26.
//

import UIKit

import SnapKit
import Then

final class NoticeView: BaseView {
    
    // MARK: - Properties

    private let type: NoticeType

    // MARK: - UI Components

    private let stackView = UIStackView()
    private let titleLabel = UILabel()

    // MARK: - Initializer

    init(type: NoticeType = .participate) {
        self.type = type
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
        }

        titleLabel.do {
            $0.setLabel(type.title, font: .caption12m, color: .gray700)
            $0.numberOfLines = 0
        }
    }

    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        type.messages.forEach { stackView.addArrangedSubview(makeMessageLabel(text: $0)) }
    }

    override func setLayout() {
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    // MARK: - Private Method

    private func makeMessageLabel(text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.setLabel(text, font: .caption12m, color: .gray700)
        return label
    }
}
