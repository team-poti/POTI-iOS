//
//  MemberBottomSheet.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class MemberBottomSheet: BaseView {
    
    // MARK: - Properties
    
    private let viewModel: MemberViewModel
    var onComplete: (([String]) -> Void)?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    
    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let bottomButtonStackView = UIStackView()
    private let resetButton = PotiBottomButton()
    private let completeButton = PotiBottomButton()
    
    // MARK: - Initializer
    
    init(viewModel: MemberViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        setAddTarget()
        
        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.6)
        }
        
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }
        
        closeButton.do {
            $0.setImage(.icnX, for: .normal)
        }
        
        titleLabel.do {
            $0.text = "멤버 선택"
            $0.font = PotiFontManager.title18sb.font
            $0.textColor = .potiBlack
        }
        
        collectionView.do {
            let layout = UICollectionViewFlowLayout()
            let totalPadding: CGFloat = 20 + 20 + 13
            let width = (UIScreen.main.bounds.width - totalPadding) / 2
            
            layout.itemSize = CGSize(width: width, height: 56)
            layout.minimumInteritemSpacing = 13
            layout.minimumLineSpacing = 12
            layout.scrollDirection = .vertical
            
            $0.collectionViewLayout = layout
            $0.register(MemberCell.self, forCellWithReuseIdentifier: MemberCell.identifier)
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        }
        
        bottomButtonStackView.do {
            $0.backgroundColor = .clear
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.spacing = 10
        }
        
        resetButton.do {
            $0.size = .small
            $0.color = .secondarySub
            $0.text = "초기화"
        }
        
        completeButton.do {
            $0.size = .medium
            $0.color = .deactiveMain
            $0.text = "완료"
            $0.isDisabled = true
        }
    }
    
    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(
            closeButton,
            titleLabel,
            collectionView,
            bottomButtonStackView
        )
        bottomButtonStackView.addArrangedSubviews(resetButton, completeButton)
    }
    
    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(4)
            $0.size.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72)
            $0.leading.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(492)
            $0.bottom.equalTo(bottomButtonStackView.snp.top).inset(40)
        }
        
        bottomButtonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(38)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(4)
        }
    }
    
    private func setAddTarget() {
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.output.memberList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.collectionView.reloadData() }
            .store(in: &cancellables)
        
        viewModel.output.isCompleteEnabled
            .receive(on: RunLoop.main)
            .sink { [weak self] isEnabled in
                self?.completeButton.isDisabled = !isEnabled
                self?.completeButton.color = isEnabled ? .secondaryMain : .deactiveMain
            }
            .store(in: &cancellables)
        
        viewModel.output.selectedMembers
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedList in
                self?.onComplete?(selectedList)
                self?.dismiss()
            }
            .store(in: &cancellables)
    }
    
    @objc private func didTapReset() {
        viewModel.action(.tapReset)
    }
    
    @objc private func didTapComplete() {
        viewModel.action(.tapComplete)
    }
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        backgroundView.alpha = 0
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.containerView.transform = .identity
            self.backgroundView.alpha = 1
        }
    }
}

// MARK: - Extension

extension MemberBottomSheet: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.currentMemberList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MemberCell.identifier,
            for: indexPath
        ) as? MemberCell else { return UICollectionViewCell() }
        
        let data = viewModel.currentMemberList[indexPath.item]
        cell.configure(name: data.name, style: data.isSelected ? .selected : .unselected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.action(.selectMember(index: indexPath.item))
    }
}
