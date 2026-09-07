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
    private weak var keyboardAvoidingScrollView: UIScrollView?
    private weak var keyboardFocusScopeView: UIView?
    private var keyboardEndFrame: CGRect?
    private var keyboardAvoidancePadding: CGFloat = 0
    private var originalScrollInsets: UIEdgeInsets = .zero
    private var originalIndicatorInsets: UIEdgeInsets = .zero
    private var isKeyboardAvoidanceEnabled = false
    
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

    func enableKeyboardAvoidance(for scrollView: UIScrollView, focusScopeView: UIView, padding: CGFloat = 12) {
        keyboardAvoidingScrollView = scrollView
        keyboardFocusScopeView = focusScopeView
        keyboardAvoidancePadding = padding
        originalScrollInsets = scrollView.contentInset
        originalIndicatorInsets = scrollView.verticalScrollIndicatorInsets

        guard !isKeyboardAvoidanceEnabled else { return }
        isKeyboardAvoidanceEnabled = true

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { notification in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            }
            .receive(on: RunLoop.main)
            .sink { [weak self] keyboardEndFrame in
                self?.updateKeyboardAvoidance(with: keyboardEndFrame)
            }
            .store(in: &cancellables)

        Publishers.Merge(
            NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification),
            NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification)
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] notification in
            guard let inputView = notification.object as? UIView else { return }
            self?.scrollToVisibleIfNeeded(inputView)
        }
        .store(in: &cancellables)
    }

    private func updateKeyboardAvoidance(with keyboardEndFrame: CGRect) {
        guard let scrollView = keyboardAvoidingScrollView else { return }
        self.keyboardEndFrame = keyboardEndFrame
        view.layoutIfNeeded()

        let scrollFrame = scrollView.convert(scrollView.bounds, to: view)
        let convertedKeyboardFrame = view.convert(keyboardEndFrame, from: nil)
        let overlap = max(0, scrollFrame.maxY - convertedKeyboardFrame.minY)
        let additionalInset = overlap > 0 ? overlap + keyboardAvoidancePadding : 0

        scrollView.contentInset.bottom = originalScrollInsets.bottom + additionalInset
        scrollView.verticalScrollIndicatorInsets.bottom = originalIndicatorInsets.bottom + additionalInset

        guard overlap > 0,
              let focusScopeView = keyboardFocusScopeView,
              let focusedInputView = focusScopeView.firstResponder else { return }
        scrollToVisible(focusedInputView)
    }

    private func scrollToVisibleIfNeeded(_ inputView: UIView) {
        guard let keyboardEndFrame,
              let focusScopeView = keyboardFocusScopeView,
              inputView.isDescendant(of: focusScopeView) else { return }

        let convertedKeyboardFrame = view.convert(keyboardEndFrame, from: nil)
        guard convertedKeyboardFrame.minY < view.bounds.maxY else { return }
        scrollToVisible(inputView)
    }

    private func scrollToVisible(_ inputView: UIView) {
        guard let scrollView = keyboardAvoidingScrollView,
              let focusScopeView = keyboardFocusScopeView else { return }

        var targetView = inputView
        while let superview = targetView.superview, superview !== focusScopeView {
            targetView = superview
        }

        let targetRect = targetView.convert(targetView.bounds, to: scrollView)
            .insetBy(dx: 0, dy: -keyboardAvoidancePadding)
        scrollView.scrollRectToVisible(targetRect, animated: true)
    }
    
    // MARK: - Navigation Setting
    
    @objc func navigationButtonTapped(_ sender: UIButton) {
        guard let action = PotiNavigationAction(rawValue: sender.tag) else { return }

        switch action {
        case .back, .xButton:
            if let navController = self.navigationController,
               navController.viewControllers.first == self {
                self.tabBarController?.selectedIndex = 0
            } else if self.navigationController == nil {
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
