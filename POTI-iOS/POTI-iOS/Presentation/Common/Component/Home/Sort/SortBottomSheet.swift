//
//  SortBottomSheet.swift
//  POTI-iOS
//
//  Created by mandoo on 1/16/26.
//

import UIKit

import SnapKit
import Then

final class SortBottomSheet: BaseView {
    
    // MARK: - Properties
    
    private var options: [String] = []
    private var selectedIndex: Int = 0
    private var onSelect: ((Int) -> Void)?
    
    // MARK: - UI Components
    
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private lazy var tableView = UITableView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        setAddTarget()
        
        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.4)
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
            
            // MARK: - 서현이꺼 머지하고 extension 적용해서 cell 등록 수정하기
            
            $0.delegate = self
            $0.dataSource = self
            $0.register(SortCell.self, forCellReuseIdentifier: SortCell.identifier)
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
            $0.bottom.equalToSuperview().inset(75)
        }
    }
    
    private func setAddTarget() {
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    
    func configure(options: [String], selectedIndex: Int, completion: @escaping (Int) -> Void) {
        self.options = options
        self.selectedIndex = selectedIndex
        self.onSelect = completion
        
        tableView.reloadData()
        
        tableView.layoutIfNeeded()
        let contentHeight = tableView.contentSize.height+20
        
        tableView.snp.remakeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(75)
            $0.height.equalTo(contentHeight)
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
    
    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 500)
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - Extension

extension SortBottomSheet: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SortCell.identifier, for: indexPath) as? SortCell else { return UITableViewCell() }
        
        cell.configure(text: options[indexPath.row], isSelected: indexPath.row == selectedIndex)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.onSelect?(indexPath.row)
            self.dismiss()
        }
    }
}
