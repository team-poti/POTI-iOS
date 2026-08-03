//
//  SearchListView.swift
//  POTI-iOS
//
//  Created by soomin on 8/3/26.
//

import UIKit

import SnapKit
import Then

final class SearchListView<Item>: BaseView, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    private let maxVisibleRows: Int

    var onSelectItem: ((Item) -> Void)?

    private var items: [Item] = [] {
        didSet {
            tableView.reloadData()
            tableView.isScrollEnabled = items.count > maxVisibleRows
            updateHeightIfNeeded()
        }
    }

    var itemsCount: Int { items.count }
    private let rowHeight: CGFloat = 52
    private let titleProvider: (Item) -> String

    var requiredHeight: CGFloat {
        let visibleRows = min(maxVisibleRows, items.count)
        return CGFloat(visibleRows) * rowHeight
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: requiredHeight)
    }

    // MARK: - UI Components

    private let boxView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Initializer

    init(titleProvider: @escaping (Item) -> String, maxVisibleRows: Int) {
        self.titleProvider = titleProvider
        self.maxVisibleRows = max(1, maxVisibleRows)
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        backgroundColor = .clear
        boxView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.gray700.cgColor
            $0.layer.masksToBounds = true

        }

        tableView.do {
            $0.separatorStyle = .singleLine
            $0.separatorInset = .zero
            $0.separatorColor = .gray700
            $0.sectionHeaderTopPadding = 0
            $0.contentInset = .zero
            $0.scrollIndicatorInsets = .zero
            $0.contentInsetAdjustmentBehavior = .never
            $0.tableHeaderView = UIView(frame: .zero)
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = false
            $0.backgroundColor = .clear
            $0.tableFooterView = UIView()
            $0.delaysContentTouches = false
            $0.canCancelContentTouches = true
            $0.keyboardDismissMode = .none
            $0.register(SearchListCell.self, forCellReuseIdentifier: SearchListCell.identifier)
            $0.dataSource = self
            $0.delegate = self
            $0.rowHeight = rowHeight
            $0.bounces = false
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

    // MARK: - Private Method

    private func updateHeightIfNeeded() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }

    // MARK: - Public Methods

    func setItems(_ items: [Item]) {
        self.items = items
    }

    func clear() {
        items = []
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchListCell.identifier, for: indexPath) as? SearchListCell else {
            return UITableViewCell()
        }
        cell.configure(with: titleProvider(items[indexPath.row]))
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectItem?(items[indexPath.row])
    }
}
