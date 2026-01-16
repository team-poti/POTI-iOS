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
    
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    private lazy var allButton = makeFilterButton(type: .all)
    private lazy var ongoingButton = makeFilterButton(type: .ongoing)
    private lazy var completedButton = makeFilterButton(type: .completed)
    
    private let firstDivider = UIView().then {
        $0.backgroundColor = .poti200
    }
    private let secondDivider = UIView().then {
        $0.backgroundColor = .poti200
    }
    
    private var buttons: [MyPageNavigationType: UIButton] = [:]
    private var countLabels: [MyPageNavigationType: UILabel] = [:]
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttons = [.all: allButton, .ongoing: ongoingButton, .completed: completedButton]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setStyle() {
        backgroundColor = .clear
        
        containerView.do {
            $0.backgroundColor = .poti200
            $0.layer.cornerRadius = 16
        }
        
        stackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 0
        }
        
        // 초기 선택 상태
        updateButtonState(selected: .all)
    }
    
    override func setUI() {
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(allButton)
        stackView.addArrangedSubview(firstDivider)
        stackView.addArrangedSubview(ongoingButton)
        stackView.addArrangedSubview(secondDivider)
        stackView.addArrangedSubview(completedButton)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(120)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
        
        [firstDivider, secondDivider].forEach { divider in
            divider.snp.makeConstraints {
                $0.width.equalTo(1)
                $0.top.bottom.equalToSuperview()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func makeFilterButton(type: MyPageNavigationType) -> UIButton {
        let button = UIButton()
        button.tag = type.rawValue
        button.layer.cornerRadius = 12
        
        // 버튼 내부 스택뷰
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        
        // 숫자 라벨
        let countLabel = UILabel()
        countLabel.font = PotiFontManager.display20b.font
        countLabel.textAlignment = .center
        
        // 타이틀 라벨
        let titleLabel = UILabel()
        titleLabel.text = type.title
        titleLabel.font = PotiFontManager.body16m.font
        titleLabel.textAlignment = .center
        
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(titleLabel)
        
        button.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        countLabels[type] = countLabel
        
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func updateButtonState(selected: MyPageNavigationType) {
        MyPageNavigationType.allCases.forEach { type in
            guard let button = buttons[type],
                  let countLabel = countLabels[type],
                  let titleLabel = button.subviews.compactMap({ $0 as? UIStackView }).first?.arrangedSubviews[1] as? UILabel else { return }
            
            let isSelected = type == selected
            
            button.backgroundColor = isSelected ? .potiWhite : .clear
            countLabel.textColor = isSelected ? .poti800 : .poti400
            titleLabel.textColor = isSelected ? .poti800 : .poti400
        }
        
        selectedFilter = selected
    }
    
    // MARK: - Actions
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        guard let type = MyPageNavigationType(rawValue: sender.tag) else { return }
        
        updateButtonState(selected: type)
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
    
    func selectFilter(_ type: MyPageNavigationType) {
        updateButtonState(selected: type)
    }
}
