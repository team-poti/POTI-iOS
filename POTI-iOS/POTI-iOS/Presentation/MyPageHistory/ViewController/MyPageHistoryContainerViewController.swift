//
//  MyPageHistoryContainerViewController.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import Combine

enum MyPageHistoryEntryPoint {
    case tabBar
    case myPage
}

final class MyPageHistoryContainerViewController: BaseViewController<MyPageHistoryViewModel>, NavigationConfigurable {
    
    func navigationStyle() -> PotiNavigationStyle {
        return .backWithButton(title: currentType.title)
    }
    
    // MARK: - Properties
    
    private var currentChildVC: MyPageHistoryViewController?
    private var currentType: MyPageHistoryType = .participation
    private var initialTab: MyPageHistoryViewController.HistoryTab = .ongoing
    private let headerView = MyPageHistoryHeaderView()
    private let entryPoint: MyPageHistoryEntryPoint
    private let factory: ViewControllerFactory
    
    init(
        initialType: MyPageHistoryType,
        initialTab: MyPageHistoryViewController.HistoryTab = .ongoing,
        entryPoint: MyPageHistoryEntryPoint,
        viewModel: MyPageHistoryViewModel,
        factory: ViewControllerFactory
    ) {
        self.currentType = initialType
        self.initialTab = initialTab
        self.entryPoint = entryPoint
        self.factory = factory
        super.init(viewModel: viewModel)
        hidesBottomBarWhenPushed = entryPoint == .myPage
        headerView.updateSelection(initialType)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.action(.viewDidLoad)
        switchChildViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(
            entryPoint == .tabBar,
            animated: false
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if entryPoint == .tabBar {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    override func setUI() {
        guard entryPoint == .tabBar else { return }
        view.addSubview(headerView)
    }

    override func setLayout() {
        guard entryPoint == .tabBar else { return }
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }

    override func addTarget() {
        headerView.onTypeSelected = { [weak self] type in
            self?.viewModel.action(.typeSelected(type))
        }
    }
    
    override func bindViewModel() {
        viewModel.output.currentType
            .dropFirst()
            .sink { [weak self] type in
                self?.currentType = type
                self?.headerView.updateSelection(type)
                self?.switchChildViewController()
                self?.updateNavigationBar()
            }
            .store(in: &cancellables)
    }
    
    private func updateNavigationBar() {
        guard entryPoint == .myPage else { return }
        PotiNavigationBar.configure(
            navigationItem: navigationItem,
            navigationController: navigationController,
            style: .backWithButton(title: currentType.title),
            target: self
        )
    }
    
    private func switchChildViewController() {
        if let currentChildVC = currentChildVC {
            currentChildVC.willMove(toParent: nil)
            currentChildVC.view.removeFromSuperview()
            currentChildVC.removeFromParent()
        }
        
        let childVC = MyPageHistoryViewController(viewModel: viewModel, initialTab: initialTab, factory: factory)
        addChild(childVC)
        view.addSubview(childVC.view)
        childVC.view.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            if entryPoint == .tabBar {
                $0.top.equalTo(headerView.snp.bottom)
            } else {
                $0.top.equalToSuperview()
            }
        }
        childVC.didMove(toParent: self)
        
        currentChildVC = childVC
        
        initialTab = .ongoing
    }
    
    // MARK: - Navigation Actions
    
    override func changeButtonTapped() {
        viewModel.action(.switchButtonTapped)
    }
}
