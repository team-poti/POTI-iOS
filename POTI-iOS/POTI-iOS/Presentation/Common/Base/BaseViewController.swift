//
//  BaseViewController.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/9/26.
//

import UIKit

class BaseViewController<VM>: UIViewController, NavigationActionHandling {
    
    private(set) var viewModel: VM?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .potiWhite

        PotiLogger.lifecycle("viewDidLoad 호출 - \(type(of: self))")

        hideKeyboardWhenTappedAround()
        setUI()
        setLayout()
        addTarget()
        setDelegate()
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
    
    // MARK: - Bind
    
    open func bind(viewModel: VM) {
        self.viewModel = viewModel
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
