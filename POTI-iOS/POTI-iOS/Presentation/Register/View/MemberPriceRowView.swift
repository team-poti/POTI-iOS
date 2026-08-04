//
//  MemberPriceRowView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/17/26.
//

import UIKit

import SnapKit
import Then

final class MemberPriceRowView: BaseView, UITextFieldDelegate {

    // MARK: - Public

    let index: Int

    /// (rowIndex, currentPrice)
    var onPriceChanged: ((Int, Int?) -> Void)?
    var onBeginEditing: ((Int) -> Void)?

    // 외부에서 필요하면 참조할 수 있게 열어둔다 (VC에서 endEditing 등).
    let priceTextField = UITextField()

    // MARK: - UI

    private let nameLabel = UILabel()
    private let underlineView = UIView()
    private let wonLabel = UILabel()

    // MARK: - Init

    init(index: Int = 0) {
        self.index = index
        super.init(frame: .zero)
        priceTextField.delegate = self
        addTargets()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - BaseView

    override func setStyle() {
        backgroundColor = .clear
        isUserInteractionEnabled = true

        nameLabel.do {
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.numberOfLines = 1
            $0.isUserInteractionEnabled = false
        }

        priceTextField.do {
            $0.font = PotiFontManager.body16sb.font
            $0.textColor = .potiBlack
            $0.textAlignment = .right
            // ⚠️ 이거 켜면 터치/커서 이상해지는 케이스가 꽤 있음. 필요 없으면 끄는 게 맞다.
            $0.semanticContentAttribute = .unspecified
            $0.keyboardType = .numberPad
            $0.borderStyle = .none
            $0.clearButtonMode = .never
            $0.isEnabled = true
            $0.isUserInteractionEnabled = true
        }

        underlineView.do {
            $0.backgroundColor = .gray300
            $0.isUserInteractionEnabled = false
        }

        wonLabel.do {
            $0.text = "원"
            $0.font = PotiFontManager.body16m.font
            $0.textColor = .potiBlack
            $0.isUserInteractionEnabled = false
        }
    }

    override func setUI() {
        addSubviews(nameLabel, priceTextField, underlineView, wonLabel)
    }

    override func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(priceTextField.snp.centerY)
        }

        wonLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(priceTextField.snp.centerY)
        }

        priceTextField.snp.makeConstraints {
            $0.trailing.equalTo(wonLabel.snp.leading).offset(-4)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(28)
            $0.width.greaterThanOrEqualTo(45)
        }

        underlineView.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(priceTextField)
            $0.height.equalTo(2)
        }

        snp.makeConstraints { $0.height.equalTo(56) }

        priceTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        priceTextField.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    // MARK: - Touch 확대 (안전 버전)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // row 영역 안이면 무조건 터치 받게 한다. (stackView/scrollView 충돌 대비)
        return bounds.contains(point)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 텍필 주변 클릭 시 텍필로 라우팅
        let fieldFrame = priceTextField.frame
        let extended = fieldFrame.insetBy(dx: -24, dy: -14)
        if extended.contains(point) {
            return priceTextField
        }
        return super.hitTest(point, with: event)
    }

    // MARK: - Targets

    private func addTargets() {
        priceTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(beginEditing), for: .editingDidBegin)
    }

    @objc private func beginEditing() {
        onBeginEditing?(index)
    }

    @objc private func textDidChange() {
        // 콤마 제거
        let raw = priceTextField.text ?? ""
        let digits = raw.replacingOccurrences(of: ",", with: "")

        if digits.isEmpty {
            onPriceChanged?(index, nil)
            return
        }

        guard let number = Int(digits) else {
            // 숫자가 아니면 싹 비움
            priceTextField.text = ""
            onPriceChanged?(index, nil)
            return
        }

        // 포맷팅 (커서 튐은 감수. 지금은 '작동'이 우선)
        priceTextField.text = Self.format(number)
        onPriceChanged?(index, number)
    }

    private static func format(_ number: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: number)) ?? ""
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { true }

    // MARK: - Helpers

    var currentPrice: Int? {
        let text = priceTextField.text ?? ""
        let digits = text.replacingOccurrences(of: ",", with: "")
        return Int(digits)
    }

    func configure(name: String, price: Int?) {
        nameLabel.text = name
        if let price {
            priceTextField.text = Self.format(price)
        } else {
            priceTextField.text = ""
        }
    }
}
