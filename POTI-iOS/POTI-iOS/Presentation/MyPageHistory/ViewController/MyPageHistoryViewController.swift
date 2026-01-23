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
    private var currentType: MyPageHistoryType = .participation
    private var isScrollingByUser = false
    
    private var ongoingItems: [MyPageHistoryModel] = []
    private var completedItems: [MyPageHistoryModel] = []
    
    private let factory: ViewControllerFactory
    
    init(viewModel: MyPageHistoryViewModel, initialTab: HistoryTab = .ongoing, factory: ViewControllerFactory) {
        self.factory = factory
        self.currentTab = initialTab
        super.init(viewModel: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.updateTabSelection(to: self.currentTab, animated: false)
        }
    }
    
    // MARK: - Override Methods
    
    override func setUI() {
        view.addSubviews(tabView, contentView)
    }
    
    override func setLayout() {
        tabView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        contentView.scrollView.delegate = self
        contentView.ongoingTableView.dataSource = self
        contentView.ongoingTableView.delegate = self
        contentView.completedTableView.dataSource = self
        contentView.completedTableView.delegate = self
    }
    
    override func addTarget() {
        tabView.ongoingTabButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
        tabView.completedTabButton.addTarget(self, action: #selector(tabButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        viewModel.output.currentType
            .sink { [weak self] type in
                self?.currentType = type
            }
            .store(in: &cancellables)
        
        viewModel.output.ongoingData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.ongoingItems = data
                self.updateEmptyView(for: .ongoing, isEmpty: data.isEmpty)
                self.contentView.ongoingTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.completedData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self = self else { return }
                self.completedItems = data
                self.updateEmptyView(for: .completed, isEmpty: data.isEmpty)
                self.contentView.completedTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.output.ongoingCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.tabView.updateCount(for: .ongoing, count: count)
            }
            .store(in: &cancellables)

        viewModel.output.completedCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.tabView.updateCount(for: .completed, count: count)
            }
            .store(in: &cancellables)
    }
    
    private func updateTabSelection(to tab: HistoryTab, animated: Bool) {
        guard currentTab != tab || !animated else { return }

        currentTab = tab
        
        tabView.updateTabSelection(tab: tab)
        
        let targetButton = tab == .ongoing ? tabView.ongoingTabButton : tabView.completedTabButton
        tabView.updateTabIndicator(to: targetButton, animated: animated)
        
        isScrollingByUser = false
        let offsetX = CGFloat(tab.rawValue) * view.bounds.width
        contentView.scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)
    }
    
    private func updateEmptyView(for tab: HistoryTab, isEmpty: Bool) {
        let tableView = tab == .ongoing ? contentView.ongoingTableView : contentView.completedTableView
        
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollingByUser = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard isScrollingByUser else { return }
        let pageWidth = view.bounds.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        
        if let tab = HistoryTab(rawValue: currentPage), tab != currentTab {
            currentTab = tab
            tabView.updateTabSelection(tab: tab)
            
            let targetButton = tab == .ongoing ? tabView.ongoingTabButton : tabView.completedTabButton
            tabView.updateTabIndicator(to: targetButton, animated: false)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrollingByUser = false
    }
        
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isScrollingByUser = false
        }
    }
}

// MARK: - UITableViewDataSource

extension MyPageHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == contentView.ongoingTableView {
            return ongoingItems.count
        } else {
            return completedItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyPageHistoryCell",
            for: indexPath
        ) as? MyPageHistoryCell else {
            return UITableViewCell()
        }
        
        let item = tableView == contentView.ongoingTableView
        ? ongoingItems[indexPath.row]
        : completedItems[indexPath.row]
        
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

        let item = tableView == contentView.ongoingTableView
            ? ongoingItems[indexPath.row]
            : completedItems[indexPath.row]

        navigateToDetail(item: item)
    }
}

// MARK: - Navigation

extension MyPageHistoryViewController {
    private func navigateToDetail(item: MyPageHistoryModel) {
        switch currentType {
        case .recruitment:
             //모집글 상세
            let vc = factory.makeRecruitDetailViewController(postId: item.id)
            navigationController?.pushViewController(vc, animated: true)

        // 악귀 뷰 이동
        case .participation:
             //참여 상세 (이름은 예시)
            let vc = factory.makeMyPageJoinDetailViewController(participationId: item.id)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
