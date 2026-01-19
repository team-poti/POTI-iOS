//
//  SearchListView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/15/26.
//

import UIKit

import SnapKit
import Then

final class SearchListView: BaseView {

    // MARK: - Property

    var maxVisibleRows: Int = 3 {
        didSet {
            tableView.isScrollEnabled = items.count > maxVisibleRows
            tableView.bounces = false
            updateHeightIfNeeded()
        }
    }

    var onSelectItem: ((Int, String) -> Void)?

    private var items: [String] = [] {
        didSet {
            tableView.reloadData()
            tableView.isScrollEnabled = items.count > maxVisibleRows
            tableView.bounces = false
            updateHeightIfNeeded()
        }
    }

    var itemsCount: Int { items.count }

    var requiredHeight: CGFloat {
        let visibleRows = min(maxVisibleRows, items.count)
        return CGFloat(visibleRows) * rowHeight
    }

    private let rowHeight: CGFloat = 52

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: requiredHeight)
    }

    // MARK: - UI Components

    private let boxView: UIView = {
        let view = UIView()
        view.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray700.cgColor
            $0.layer.masksToBounds = true
        }
        return view
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.do {
            $0.separatorStyle = .singleLine
            $0.separatorInset = .zero
            $0.separatorColor = .gray700
            if #available(iOS 15.0, *) {
                $0.sectionHeaderTopPadding = 0
            }
            $0.contentInset = .zero
            $0.scrollIndicatorInsets = .zero
            $0.contentInsetAdjustmentBehavior = .never
            $0.tableHeaderView = UIView(frame: .zero)
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = false
            $0.backgroundColor = .clear
            $0.rowHeight = 52
            $0.tableFooterView = UIView()
        }
        return tableView
    }()

    // MARK: - Life Cycle

    override func setStyle() {
        backgroundColor = .clear

        tableView.do {
            $0.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    }

    override func setUI() {
        addSubview(boxView)
        boxView.addSubview(tableView)
    }

    override func setLayout() {
        boxView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Custom Method

    func setItems(_ items: [String]) {
        self.items = items
        invalidateIntrinsicContentSize()
    }

    func clear() {
        items = []
        invalidateIntrinsicContentSize()
    }

    private func updateHeightIfNeeded() {
        // 부모가 height constraint를 주지 않아도(StackView 포함) 자동 높이 계산이 되도록 intrinsic size 갱신
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - UITableViewDataSource

extension SearchListView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchListCell.identifier,
            for: indexPath
        ) as! SearchListCell
        cell.configure(text: items[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchListView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectItem?(indexPath.row, items[indexPath.row])
    }
}
