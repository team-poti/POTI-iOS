//
//  AccordionDropdownView.swift
//  POTI-iOS
//
//  Created by mandoo on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class AccordionDropdownView: BaseView {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let tableView = UITableView()
    weak var anchorView: UIView?
    private let whiteLayerView = UIView()
    
    // MARK: - Properties
    
    private var maxHeight: CGFloat
    var onSelect: ((String) -> Void)?
    var onClose: (() -> Void)?
    private var heightConstraint: Constraint?
    private var isOpen = false
    private var displayItems: [(name: String, price: Int)]
    private var disabledIndices: Set<Int> = []
    var onSelectIndex: ((Int) -> Void)?
    
    // MARK: - Initializer
    
    init(items: [(name: String, price: Int)], disabledIndices: Set<Int> = [], maxHeight: CGFloat = 422) {
        self.displayItems = items
        self.disabledIndices = disabledIndices
        self.maxHeight = maxHeight
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let containerPoint = convert(point, to: containerView)
            if containerView.bounds.contains(containerPoint) {
                return super.hitTest(point, with: event)
            }
            
            if let anchor = anchorView {
                let anchorPoint = convert(point, to: anchor)
                if anchor.bounds.contains(anchorPoint) {
                    return nil
                }
            }
            return super.hitTest(point, with: event)
    }
    
    // MARK: - Method
    
    func open(below anchorView: UIView, in parent: UIView, bottomAnchorView: UIView) {
        guard !isOpen else { return }
        isOpen = true
        
        self.alpha = 0
        frame = parent.bounds
        parent.addSubview(self)
        parent.bringSubviewToFront(anchorView)
        
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
        
        let totalContentHeight = CGFloat(displayItems.count) * tableView.rowHeight
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
    
    @objc func close() {
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

// MARK: - Extension

extension AccordionDropdownView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let item = displayItems[indexPath.row]
        let isDisabled = disabledIndices.contains(indexPath.row)
        
        cell.isUserInteractionEnabled = !isDisabled
        
        let titleLabel = UILabel().then {
            $0.text = item.name
            $0.font = PotiFontManager.body14m.font
            $0.textColor = isDisabled ? .gray700 : .potiBlack
        }
        
        let priceLabel = UILabel().then {
            $0.text = item.price == 0 ? "0원" : "\(item.price.formattedWithComma)원"
            $0.font = PotiFontManager.body14sb.font
            $0.textColor = isDisabled ? .gray700 : .potiBlack
        }
        
        cell.contentView.addSubviews(titleLabel, priceLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .potiWhite
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectIndex?(indexPath.row)
        close()
    }
}
