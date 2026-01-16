//
//  BaseViewController.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/9/26.
//

import UIKit

import Combine

class BaseViewController<VM: BaseViewModelType>: UIViewController, NavigationActionHandling {
    
    private(set) var viewModel: VM
    public var cancellables = Set<AnyCancellable>()
    private var didSetupLayout = false
    
    public init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .potiWhite

        PotiLogger.lifecycle("viewDidLoad 호출 - \(type(of: self))")
        
        view.backgroundColor = .potiWhite
        hideKeyboardWhenTappedAround()
        setUI()
        addTarget()
        setDelegate()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !didSetupLayout {
            setLayout()
            didSetupLayout = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PotiLogger.lifecycle("viewWillAppear 호출 - \(type(of: self))")
        
        guard let configurable = self as? NavigationConfigurable else { return }

        PotiNavigationBar.configure(navigationItem: navigationItem, navigationController: navigationController, style: configurable.navigationStyle(), target: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        PotiLogger.lifecycle("viewDidAppear 호출 - \(type(of: self))")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PotiLogger.lifecycle("viewWillDisappear 호출 - \(type(of: self))")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        PotiLogger.lifecycle("viewDidDisappear 호출 - \(type(of: self))")
    }

    // MARK: - Custom Method

    /// UI 구성
    open func setUI() {}

    /// 오토레이아웃 설정
    open func setLayout() {}

    /// 버튼 / 제스처 연결
    open func addTarget() {}

    /// delegate / datasource 설정
    open func setDelegate() {}
    
    /// 뷰모델 바인딩
    open func bindViewModel() {}
    
    // MARK: - Navigation Setting
    
    @objc func navigationButtonTapped(_ sender: UIButton) {
        guard let action = PotiNavigationAction(rawValue: sender.tag) else { return }

        switch action {
        case .back, .xButton:
            if self.navigationController == nil {
                self.dismiss(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        case .search:
            searchButtonTapped()
            
        case .alarm:
            alarmButtonTapped()
            
        case .setting:
            settingButtonTapped()
            
        case .change:
            changeButtonTapped()
        }
    }

    @objc open func searchButtonTapped() {}
    @objc open func alarmButtonTapped() {}
    @objc open func settingButtonTapped() {}
    @objc open func changeButtonTapped() {}
}
