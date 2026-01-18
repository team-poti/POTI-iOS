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
    case all = 0
    case ongoing = 1
    case completed = 2
    
    var title: String {
        switch self {
        case .all: return "전체"
        case .ongoing: return "진행중"
        case .completed: return "종료"
        }
    }
}

final class MyPageNavigationView: BaseView {
    
    // MARK: - Properties
    
    var onFilterChanged: ((MyPageNavigationType) -> Void)?
    private var selectedFilter: MyPageNavigationType = .all
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    
    private lazy var allButton = makeFilterButton(type: .all)
    private lazy var ongoingButton = makeFilterButton(type: .ongoing)
    private lazy var completedButton = makeFilterButton(type: .completed)
    
    private let firstDivider = UIView().then {
        $0.backgroundColor = .gray300
    }
    private let secondDivider = UIView().then {
        $0.backgroundColor = .gray300
    }
    
    private var buttons: [MyPageNavigationType: UIButton] = [:]
    private var countLabels: [MyPageNavigationType: UILabel] = [:]
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttons = [.all: allButton, .ongoing: ongoingButton, .completed: completedButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .gray100
        layer.cornerRadius = 16
        
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 17
        }
    }
    
    override func setUI() {
        addSubviews(stackView, firstDivider, secondDivider)
        stackView.addArrangedSubviews(allButton, ongoingButton, completedButton)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(104)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        firstDivider.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(allButton.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.width.equalTo(1)
        }

        secondDivider.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(ongoingButton.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.width.equalTo(1)
        }
    }
    
    private func makeFilterButton(type: MyPageNavigationType) -> UIButton {
        let button = UIButton().then {
            $0.tag = type.rawValue
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .center
            $0.isUserInteractionEnabled = false
        }
        
        let countLabel = UILabel().then {
            $0.font = PotiFontManager.title18sb.font
            $0.textAlignment = .center
            $0.textColor = .poti600
        }
        
        let titleLabel = UILabel().then {
            $0.text = type.title
            $0.font = PotiFontManager.caption12m.font
            $0.textColor = .gray800
            $0.textAlignment = .center
        }
        
        stackView.addArrangedSubviews(countLabel, titleLabel)
        
        button.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        countLabels[type] = countLabel
        
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        button.setBackgroundImage(.fromUIColor(color: .gray100), for: .normal)
        
        button.setBackgroundImage(.fromUIColor(color: .gray300), for: .highlighted)
        
        return button
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let type = MyPageNavigationType(rawValue: sender.tag) else { return }
        
        onFilterChanged?(type)
    }
    
    // MARK: - Public Methods
    
    func configure(counts: (all: Int, ongoing: Int, completed: Int)) {
        countLabels[.all]?.text = "\(counts.all)"
        countLabels[.ongoing]?.text = "\(counts.ongoing)"
        countLabels[.completed]?.text = "\(counts.completed)"
    }
    
    func setEnabled(_ isEnabled: Bool) {
        buttons.values.forEach { button in
            button.isUserInteractionEnabled = isEnabled
        }
    }
}
