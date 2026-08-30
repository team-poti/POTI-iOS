//
//  StarRatingControl.swift
//  POTI-iOS
//
//  Created by Neon on 8/30/26.
//

import UIKit

import SnapKit

final class StarRatingControl: UIControl {
    private let stackView = UIStackView()
    private var buttons: [UIButton] = []

    private(set) var rating = 0 {
        didSet {
            updateStars()
            accessibilityValue = "5점 중 \(rating)점"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setRating(_ rating: Int, sendsEvent: Bool = false) {
        self.rating = min(max(rating, 0), 5)
        if sendsEvent {
            sendActions(for: .valueChanged)
        }
    }

    private func configureView() {
        isAccessibilityElement = true
        accessibilityLabel = "별점"
        accessibilityTraits = [.adjustable]

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = -6
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        buttons = (1...5).map { value in
            let button = UIButton(type: .custom)
            button.tag = value
            button.imageView?.contentMode = .scaleAspectFit
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            button.accessibilityLabel = "\(value)점"
            stackView.addArrangedSubview(button)
            button.snp.makeConstraints { $0.size.equalTo(48) }
            return button
        }
        updateStars()
    }

    private func updateStars() {
        for button in buttons {
            let image: UIImage = button.tag <= rating ? .icnStarFill : .icnStarEmpty
            button.setImage(image, for: .normal)
        }
    }

    @objc private func starTapped(_ sender: UIButton) {
        setRating(sender.tag, sendsEvent: true)
    }

    override func accessibilityIncrement() {
        setRating(rating + 1, sendsEvent: true)
    }

    override func accessibilityDecrement() {
        setRating(rating - 1, sendsEvent: true)
    }
}
