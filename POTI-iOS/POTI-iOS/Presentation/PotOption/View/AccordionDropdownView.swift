//
//  AccordionDropdownView.swift
//  POTI-iOS
//
//  Created by soomin on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class AccordionDropdownView: BaseView {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let tableView = UITableView()
    private let whiteLayerView = UIView()
    weak var anchorView: UIView?
    
    // MARK: - Properties
    
    var onClose: (() -> Void)?
    var onSelect: ((Int) -> Void)?
    var passthroughViews: [UIView] = []
    private var maxHeight: CGFloat
    private var heightConstraint: Constraint?
    private var isOpen = false
    private var items: [DropdownItem]
    
    // MARK: - Initializer
    
    init(items: [DropdownItem], maxHeight: CGFloat = 422) {
        self.items = items
        self.maxHeight = maxHeight
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if containerView.frame.contains(point) {
            return super.point(inside: point, with: event)
        }
        
        let isPassthroughArea = passthroughViews.contains { view in
            view.convert(view.bounds, to: self).contains(point)
        }

        return isPassthroughArea ? false : super.point(inside: point, with: event)
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.gray300.cgColor
            $0.layer.borderWidth = 1
        }
        
        tableView.do {
            $0.register(AccordionDropdownCell.self, forCellReuseIdentifier: AccordionDropdownCell.identifier)
            $0.separatorStyle = .singleLine
            $0.separatorColor = .gray300
            $0.separatorInset = .zero
            $0.backgroundColor = .potiWhite
            $0.rowHeight = 52
            $0.isScrollEnabled = false
            $0.dataSource = self
            $0.delegate = self
            $0.tableFooterView = UIView()
        }
        
        whiteLayerView.do {
            $0.backgroundColor = .potiWhite.withAlphaComponent(0.8)
        }
    }
    
    override func setUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapped))
        tapGesture.cancelsTouchesInView = false
        
        whiteLayerView.addGestureRecognizer(tapGesture)
        whiteLayerView.isUserInteractionEnabled = true
        
        addSubviews(whiteLayerView, containerView)
        containerView.addSubview(tableView)
    }
    
    override func setLayout() {
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            heightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    // MARK: - Public Method
    
    func open(below anchorView: UIView, in parent: UIView, bottomAnchorView: UIView) {
        guard !isOpen else { return }
        isOpen = true
        
        self.alpha = 0
        frame = parent.bounds
        parent.addSubview(self)
        
        let grayLineFrame = bottomAnchorView.convert(bottomAnchorView.bounds, to: parent)
        let anchorFrame = anchorView.convert(anchorView.bounds, to: parent)
        
        whiteLayerView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(anchorFrame.maxY)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(parent.snp.top).offset(grayLineFrame.minY - 16)
        }
        
        containerView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(anchorFrame.maxY + 12)
            $0.leading.equalToSuperview().offset(anchorFrame.minX)
            $0.trailing.equalToSuperview().inset(parent.bounds.width - anchorFrame.maxX)
            heightConstraint = $0.height.equalTo(0).constraint
        }
        
        self.layoutIfNeeded()
        
        let totalContentHeight = CGFloat(items.count) * tableView.rowHeight
        let finalHeight = min(totalContentHeight, maxHeight)
        tableView.isScrollEnabled = totalContentHeight > maxHeight
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
            self.alpha = 1
            self.whiteLayerView.alpha = 1
            self.heightConstraint?.update(offset: finalHeight)
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Action
    
    @objc private func backgroundViewTapped() {
        close()
    }

    func close() {
        guard isOpen else { return }
        isOpen = false
        onClose?()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn, .allowUserInteraction]) {
            self.alpha = 0
            self.heightConstraint?.update(offset: 0)
            self.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AccordionDropdownView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AccordionDropdownCell.identifier,
            for: indexPath
        ) as? AccordionDropdownCell else {
            return UITableViewCell()
        }

        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        guard item.isEnabled else { return }
        onSelect?(item.id)
        close()
    }
}
