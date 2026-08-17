//
//  MyPageNavigationView.swift
//  POTI-iOS
//
//  Created by neon on 1/16/26.
//

import UIKit

import SnapKit
import Then

enum MyPageNavigationType: Int, CaseIterable {
    case ongoing = 1
    case completed = 2
    
    var title: String {
        switch self {
        case .ongoing: return "진행중"
        case .completed: return "종료"
        }
    }
}

final class MyPageNavigationView: BaseView {
    
    // MARK: - Properties
    var onFilterChanged: ((MyPageNavigationType) -> Void)?
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    private lazy var ongoingButton = makeFilterButton(type: .ongoing, fontColor: .poti600)
    private lazy var completedButton = makeFilterButton(type: .completed, fontColor: .potiBlack)
    
    private let divider = UIView()
    
    private var buttons: [MyPageNavigationType: UIButton] = [:]
    private var countLabels: [MyPageNavigationType: UILabel] = [:]
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttons = [.ongoing: ongoingButton, .completed: completedButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .potiWhite
        layer.cornerRadius = 12
        
        titleLabel.do {
            $0.font = PotiFontManager.body14sb.font
            $0.textAlignment = .center
            $0.textColor = .potiBlack
        }
        
        stackView.do {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.spacing = 4
        }
        
        divider.do {
            $0.backgroundColor = .gray300
        }
    }
    
    override func setUI() {
        addSubviews(titleLabel, stackView)
        stackView.addArrangedSubviews(ongoingButton, divider, completedButton)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(CGFloat.dynamicH(156))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func makeFilterButton(type: MyPageNavigationType, fontColor: UIColor) -> UIButton {
        let button = UIButton().then {
            $0.tag = type.rawValue
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.isUserInteractionEnabled = false
        }
        
        let titleLabel = UILabel().then {
            $0.text = type.title
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = .gray900
            $0.textAlignment = .center
        }
        
        let countLabel = UILabel().then {
            $0.font = PotiFontManager.display18b.font
            $0.textAlignment = .center
            $0.textColor = fontColor
        }
        
        stackView.addArrangedSubviews(titleLabel, countLabel)
        
        button.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        countLabels[type] = countLabel
        
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        button.setBackgroundImage(.fromUIColor(color: .potiWhite), for: .normal)
        
        button.setBackgroundImage(.fromUIColor(color: .gray300), for: .highlighted)
        
        return button
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let type = MyPageNavigationType(rawValue: sender.tag) else { return }
        
        onFilterChanged?(type)
    }
    
    // MARK: - Public Methods
    
    func configure(title: String, counts: (ongoing: Int, completed: Int)) {
        titleLabel.text = title
        countLabels[.ongoing]?.text = "\(counts.ongoing)"
        countLabels[.completed]?.text = "\(counts.completed)"
    }
    
    func setEnabled(_ isEnabled: Bool) {
        buttons.values.forEach { button in
            button.isUserInteractionEnabled = isEnabled
        }
    }
}
