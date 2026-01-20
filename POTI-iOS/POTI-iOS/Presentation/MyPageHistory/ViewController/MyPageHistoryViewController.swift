//
//  MyPageHistoryViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import Combine

final class MyPageHistoryViewController: BaseViewController<MyPageHistoryViewModel> {
    
    
    // MARK: - Types
    
    enum HistoryTab: Int {
        case ongoing = 0
        case completed = 1
    }
    
    // MARK: - UI Components
    
    private let tabView = MyPageHistoryTabView()
    private let contentView = MyPageHistoryContentView()
    private var ongoingEmptyView: MyPageHistoryEmptyView?
    private var completedEmptyView: MyPageHistoryEmptyView?
    
    // MARK: - Properties
    
    private var currentTab: HistoryTab = .ongoing
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
        setAction()
        bind()
        updateTabSelection(to: .ongoing, animated: false)
    }
    
    // MARK: - Bind
    
    private func bind() {
        let output = viewModel.getOutput()
        
        output.ongoingData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.updateEmptyView(for: .ongoing, isEmpty: data.isEmpty)
                self?.updateTabCounts()
                self?.contentView.ongoingTableView.reloadData()
            }
            .store(in: &cancellables)
        
        output.completedData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.updateEmptyView(for: .completed, isEmpty: data.isEmpty)
                self?.updateTabCounts()
                self?.contentView.completedTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Custom Methods
    
    private func setStyle() {
        view.backgroundColor = .white
    }
    
    private func setUI() {
        view.addSubviews(tabView, contentView)
    }
    
    private func setLayout() {
        tabView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setDelegate() {
        contentView.scrollView.delegate = self
        contentView.ongoingTableView.dataSource = self
        contentView.ongoingTableView.delegate = self
        contentView.completedTableView.dataSource = self
        contentView.completedTableView.delegate = self
    }
    
    private func setAction() {
        tabView.ongoingTabButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabView.completedTabButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
    }
    
    // MARK: - Tab Management
    
    private func updateTabSelection(to tab: HistoryTab, animated: Bool) {
        currentTab = tab
        
        tabView.updateTabSelection(isOngoing: tab == .ongoing)
        
        let targetButton = tab == .ongoing ? tabView.ongoingTabButton : tabView.completedTabButton
        tabView.updateTabIndicator(to: targetButton, animated: animated)
        
        let offsetX = CGFloat(tab.rawValue) * view.bounds.width
        contentView.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
    
    private func updateTabCounts() {
        let output = viewModel.getOutput()
        let ongoingCount = output.ongoingData.value.count
        let completedCount = output.completedData.value.count
        
        tabView.updateCount(
    }
    
    // MARK: - Empty View Management
    
    private func updateEmptyView(for tab: HistoryTab, isEmpty: Bool) {
        let tableView = tab == .ongoing ? contentView.ongoingTableView : contentView.completedTableView
        let currentType = viewModel.getOutput().currentType.value
        
        if isEmpty {
            let message = currentType.emptyMessage(for: tab == .ongoing)
            let emptyView = MyPageHistoryEmptyView(message: message)
            tableView.backgroundView = emptyView
            
            if tab == .ongoing {
                ongoingEmptyView = emptyView
            } else {
                completedEmptyView = emptyView
            }
        } else {
            tableView.backgroundView = nil
            
            if tab == .ongoing {
                ongoingEmptyView = nil
            } else {
                completedEmptyView = nil
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func tabButtonTapped(_ sender: UIButton) {
        guard let tab = HistoryTab(rawValue: sender.tag) else { return }
        updateTabSelection(to: tab, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension MyPageHistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = view.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        if let tab = HistoryTab(rawValue: currentPage), tab != currentTab {
            updateTabSelection(to: tab, animated: false)
        }
    }
}

// MARK: - UITableViewDataSource

extension MyPageHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let output = viewModel.getOutput()
        
        if tableView == contentView.ongoingTableView {
            return output.ongoingData.value.count
        } else {
            return output.completedData.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyPageHistoryCell",
            for: indexPath
        ) as? MyPageHistoryCell else {
            return UITableViewCell()
        }
        
        let output = viewModel.getOutput()
        let item: HistoryItem
        
        if tableView == contentView.ongoingTableView {
            item = output.ongoingData.value[indexPath.row]
        } else {
            item = output.completedData.value[indexPath.row]
        }
        
        cell.configure(
            artist: item.artistName,
            product: item.productName,
            status: item.status,
            thumbnailURL: item.thumbnailURL
        )
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MyPageHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Handle cell tap
    }
}
