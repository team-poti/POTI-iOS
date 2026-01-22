//
//  SortBottomSheet.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

import UIKit

import Combine
import SnapKit
import Then

final class SortBottomSheet: BaseView {
    
    // MARK: - Properties
    
    private let viewModel: SortViewModel
    private var cancellables = Set<AnyCancellable>()
    var onSelectCompletion: ((Int) -> Void)?
    var onDismissCompletion: (() -> Void)?
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private lazy var tableView = UITableView()
    
    // MARK: - Initializer
    
    init(viewModel: SortViewModel) {
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
        
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(SortCell.self)
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            $0.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(closeButton, tableView)
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(41)
            $0.height.equalTo(100)
        }
    }
    
    private func bindViewModel() {
        Publishers.CombineLatest(viewModel.output.options, viewModel.output.selectedIndex)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.updateTableViewHeight()
            }
            .store(in: &cancellables)
        
        viewModel.output.onSelect
            .receive(on: RunLoop.main)
            .sink { [weak self] index in
                self?.onSelectCompletion?(index)
                self?.dismiss()
            }
            .store(in: &cancellables)
    }
    
    private func updateTableViewHeight() {
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height
        tableView.snp.updateConstraints {
            $0.height.equalTo(contentHeight)
        }
    }
    
    private func setAddTarget() {
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    
    func show(on view: UIView) {
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
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 500)
            self.backgroundView.alpha = 0
        }) { _ in
            self.onDismissCompletion?()
            self.removeFromSuperview()
        }
    }
}

// MARK: - Extension

extension SortBottomSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortCell.identifier, for: indexPath) as? SortCell else { return UITableViewCell() }
        
        let option = viewModel.currentOptions[indexPath.row]
        let isSelected = indexPath.row == viewModel.currentSelectedIndex
        let isLast = indexPath.row == viewModel.currentOptions.count - 1
        
        cell.configure(text: option, isSelected: isSelected, isLast: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.action(.selectOption(index: indexPath.row))
    }
}
