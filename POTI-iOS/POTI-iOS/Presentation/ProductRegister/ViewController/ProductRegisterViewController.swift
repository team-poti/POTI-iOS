//
//  ProductRegisterViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import Combine
import PhotosUI

final class ProductRegisterViewController:
    BaseViewController<ProductRegisterViewModel>,
    NavigationConfigurable,
    UIGestureRecognizerDelegate {
    
    // MARK: - Keyboard
    
    private weak var currentFocusedInputView: UIView?
    private var isKeyboardShown = false
    private var lastKeyboardHeight: CGFloat = 0
    func navigationStyle() -> PotiNavigationStyle {
        .xButton
    }
    
    // MARK: - Properties
    
    private let rootView = ProductRegisterView()
    private let rootBackgroundView = UIView()
    private let factory: ViewControllerFactory
    private let titleQuerySubject = PassthroughSubject<String, Never>()
    
    // MARK: - Initializer

    init(
        viewModel: ProductRegisterViewModel,
        factory: ViewControllerFactory
    ) {
        self.factory = factory
        super.init(viewModel: viewModel)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imagePickerView: ImagePickerView {
        rootView.imagePickerView
    }
    private var registerInfoView: RegisterInfoView {
        rootView.registerInfoView
    }
    private var registerMemberView: RegisterMemberView {
        rootView.registerMemberView
    }
    private var noticeView: RegisterNoticeView {
        rootView.registerNoticeView
    }
    private var currentImages: [UIImage] = []
    
    
    // MARK: - Life Cycle
    
    override func loadView() {
        rootBackgroundView.backgroundColor = .systemBackground

        rootBackgroundView.addSubview(rootView)
        rootView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: rootBackgroundView.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: rootBackgroundView.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: rootBackgroundView.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: rootBackgroundView.bottomAnchor)
        ])

        self.view = rootBackgroundView
    }
    
    private var isInputReady = false

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isInputReady = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        print("🧠 willAppear presented=", String(describing: self.presentedViewController))
        print("🧠 nav.presented=", String(describing: self.navigationController?.presentedViewController))
        print("🧠 view.window=", String(describing: self.view.window))
        

        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }

        registerInfoView.artistField.setFocused(false)
        registerInfoView.deadlineField.setFocused(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = false
        }
    }
    
    // MARK: - UI Setting
    
    override func setUI() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        noticeView.configure(
            title: "모집자 안내 사항",
            bodyTexts: [
                "굿즈 구매 가능 기간을 고려해 분철팟 마감 기간을 설정해주세요.",
                "마감 기간까지 모집 인원이 과반수 이상 충족되지 않을 경우 해당 분철팟은 자동으로 종료되며 분철은 진행되지 않습니다.",
                "분철팟 모집, 굿즈 구매, 배송 및 참여자와의 거래 과정에서 발생하는 사항에 대한 책임은 모집자에게 있습니다."
            ]
        )
        
        rootView.registerShippingView.configure(options: [
            (name: "일반택배", price: 4000),
            (name: "준등기", price: 1800)
        ])
        
        registerInfoView.artistField.onTapField = { [weak self] in
            guard let self else { return }
            self.presentArtistSearch()
        }

        registerInfoView.onTapDeadlineField = { [weak self] in
            guard let self else { return }

            self.registerInfoView.deadlineField.setFocused(true)

            let estimatedSheetHeight: CGFloat = 465
            self.scrollIfNeeded(
                for: self.registerInfoView.deadlineField,
                coveredHeight: estimatedSheetHeight
            )

            self.presentDeadlineBottomSheet()
        }
        
        //TODO: - ArtistEdit으로 교체
//        registerMemberView.onTapEditButton = { [weak self] in
//            guard let self else { return }
//
//            let sheetVM = factory.makeArtistsViewModel()
//            let bottomSheet = ArtistsBottomSheet(viewModel: sheetVM)
//
//            bottomSheet.onComplete = { [weak self] members in
//                self?.viewModel.action(.setMembers(members))
//            }
//
//            bottomSheet.show(in: self.view)
//        }

        registerMemberView.onMembersChanged = { [weak self] members in
            self?.viewModel.action(.setMembers(members))
        }

        registerInfoView.productTypeField.onQueryChanged = { [weak self] keyword in
            self?.titleQuerySubject.send(keyword)
        }

        registerInfoView.productTypeField.onSelectItem = { [weak self] _, value in
            guard let self else { return }
            self.registerInfoView.productTypeField.setText(value)
            self.registerInfoView.productTypeField.clearItems()
        }

        registerInfoView.onInputViewDidBeginEditing = { [weak self] inputView in
            guard let self else { return }
            self.currentFocusedInputView = inputView

            guard self.lastKeyboardHeight > 0 else { return }

            self.scrollIfNeeded(
                for: inputView,
                coveredHeight: self.lastKeyboardHeight
            )
        }
        rootView.contentScrollView.delaysContentTouches = false
        rootView.contentScrollView.canCancelContentTouches = true

        let _: (UIGestureRecognizer) -> Void = { [weak self] gesture in
            guard let self else { return }
            if let tap = gesture as? UITapGestureRecognizer {
                tap.cancelsTouchesInView = false
                tap.delegate = self
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var v: UIView? = touch.view
        while let view = v {
            if view is UIControl { return false }
            v = view.superview
        }
        return true
    }
    
    // MARK: - Keyboard Avoidance
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardShown else { return }
        guard
            let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let inputView = currentFocusedInputView
        else { return }

        lastKeyboardHeight = keyboardHeight

        scrollIfNeeded(
            for: inputView,
            coveredHeight: keyboardHeight
        )

        isKeyboardShown = true
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        guard isKeyboardShown else { return }
        isKeyboardShown = false
    }
    
    private func scrollIfNeeded(for inputView: UIView, coveredHeight: CGFloat) {
        let inputFrame = inputView.convert(inputView.bounds, to: view)
        let inputBottomY = inputFrame.maxY

        let isSearchField = inputView is CustomSearchField

        let dropdownHeight: CGFloat = isSearchField ? 168 : 0
        rootView.contentScrollView.contentInset.bottom = dropdownHeight

        let visibleHeight = view.frame.height - coveredHeight

        let baseOffset: CGFloat
        if inputBottomY > visibleHeight {
            baseOffset = inputBottomY - visibleHeight + 30
        } else {
            baseOffset = 0
        }

        let totalOffset = baseOffset + dropdownHeight
        guard totalOffset > 0 else { return }

        let maxOffsetY = max(
            0,
            rootView.contentScrollView.contentSize.height
            - rootView.contentScrollView.bounds.height
            + rootView.contentScrollView.contentInset.bottom
        )

        let targetOffsetY = min(
            rootView.contentScrollView.contentOffset.y + totalOffset,
            maxOffsetY
        )

        rootView.contentScrollView.setContentOffset(
            CGPoint(x: 0, y: targetOffsetY),
            animated: true
        )
    }
        
    // MARK: - Custom Method

    override func bindViewModel() {
        titleQuerySubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] keyword in
                guard let self else { return }

                if keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.registerInfoView.productTypeField.clearItems()
                    return
                }

                self.viewModel.action(.fetchTitles(keyword: keyword))
            }
            .store(in: &cancellables)
        
        viewModel.output.images
            .receive(on: RunLoop.main)
            .sink { [weak self] images in
                guard let self else { return }
                self.currentImages = images
                self.imagePickerView.setImages(images)
            }
            .store(in: &cancellables)
        
        viewModel.output.requestPicker
            .receive(on: RunLoop.main)
            .sink { [weak self] remainingLimit in
                self?.presentPicker(selectionLimit: remainingLimit)
            }
            .store(in: &cancellables)
        
        viewModel.output.titles
            .receive(on: RunLoop.main)
            .sink { [weak self] titles in
                guard let self else { return }
                self.registerInfoView.productTypeField.setItems(titles)
            }
            .store(in: &cancellables)
        
        viewModel.output.fieldErrors
            .receive(on: RunLoop.main)
            .sink { [weak self] errors in
                guard let self else { return }
                
                if let message = errors.images {
                    self.rootView.imagePickerView.showError(message)
                } else {
                    self.rootView.imagePickerView.hideError()
                }
                
                if let message = errors.artist {
                    self.registerInfoView.artistField.apply(state: .error(message))
                } else {
                    self.registerInfoView.artistField.apply(state: .normal)
                }
                
                if let message = errors.productType {
                    self.registerInfoView.productTypeField.showError(message)
                } else {
                    self.registerInfoView.productTypeField.hideError()
                }
                
                if let message = errors.deadline {
                    self.registerInfoView.deadlineField.apply(state: .error(message))
                } else {
                    self.registerInfoView.deadlineField.apply(state: .normal)
                }
                
                if let message = errors.description {
                    self.registerInfoView.descriptionField.apply(state: .error(message))
                } else {
                    self.registerInfoView.descriptionField.apply(state: .normal)
                }
                
                if let message = errors.accountNumber {
                    self.registerInfoView.accountField.apply(state: .error(message))
                } else {
                    self.registerInfoView.accountField.apply(state: .normal)
                }
                
                if let message = errors.bank {
                    self.registerInfoView.bankField.apply(state: .error(message))
                } else {
                    self.registerInfoView.bankField.apply(state: .normal)
                }
                
                if let message = errors.members {
                    self.registerMemberView.showEditedEmptyError(message: message)
                } else {
                    self.registerMemberView.hideEditedEmptyError()
                }
            }
            .store(in: &cancellables)
        
        viewModel.output.members
            .receive(on: RunLoop.main)
            .sink { [weak self] memberNames in
                guard let self else { return }

                self.registerMemberView.configure(members: memberNames)
            }
            .store(in: &cancellables)

        viewModel.output.didRegister
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                print("✅ POST 성공")
                if let nav = self?.navigationController {
                    nav.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)

        viewModel.output.registerFailed
            .receive(on: RunLoop.main)
            .sink { message in
                print("❌ POST 실패:", message)
            }
            .store(in: &cancellables)
    }

    // MARK: - Navigation Action

    override func navigationButtonTapped(_ sender: UIButton) {
        guard let action = PotiNavigationAction(rawValue: sender.tag) else { return }

        switch action {
        case .xButton, .back:
            showExitAlert(for: action)
        default:
            super.navigationButtonTapped(sender)
        }
    }

    private func showExitAlert(for action: PotiNavigationAction) {
        let alert = CustomAlertView(
            title: "지금 나가면 내용이 저장되지 않아요",
            message: "계속 작성할까요?",
            cancelTitle: "나가기",
            confirmTitle: "계속 작성하기",
            onLeftButton: { [weak self] in
                guard let self else { return }

                if self.navigationController == nil {
                    self.dismiss(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            },
            onRightButton: {
            }
        )
        alert.show(on: navigationController?.view ?? view)
    }

    // MARK: - Action Method
    
    override func addTarget() {
        imagePickerView.onTapAdd = { [weak self] in
            self?.viewModel.action(.tapAdd)
        }
        
        imagePickerView.onTapDelete = { [weak self] index in
            self?.viewModel.action(.tapDelete(index))
        }
        
        rootView.registerSubmitButton.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
    }
    
    @objc private func tapSubmit() {
        view.endEditing(true)

        let memberPrices = registerMemberView.collectPrices()
        let draft = registerInfoView.collectDraft()

        viewModel.action(
            .submit(
                info: draft,
                memberPrices: memberPrices
            )
        )
    }
    
    // MARK: - Custom Method
    
    private func findRegisterMemberView(in view: UIView) -> RegisterMemberView? {
        if let target = view as? RegisterMemberView {
            return target
        }
        for sub in view.subviews {
            if let found = findRegisterMemberView(in: sub) {
                return found
            }
        }
        return nil
    }
    
    private func presentPicker(selectionLimit: Int) {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = max(0, selectionLimit)
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func presentDeadlineBottomSheet() {
        let sheetVC = DeadlinePickerSheetViewController(
            initialDate: Date(),
            onConfirm: { [weak self] date in
                guard let self else { return }
                self.registerInfoView.deadlineField.setText(Self.format(date))
                self.viewModel.action(.deadlineSelected(date))
                self.registerInfoView.deadlineField.setFocused(false)
            },
            onCancel: { [weak self] in
                self?.registerInfoView.deadlineField.setFocused(false)
            }
        )
        
        if let sheet = sheetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 16
        }
        
        present(sheetVC, animated: true)
    }
    
    private static func format(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func presentArtistSearch() {
        
        let searchVC = factory.makeArtistSearchViewController()

        searchVC.onSelectArtist = { [weak self] artist in
            guard let self else { return }
            self.view.endEditing(true)
            self.registerInfoView.artistField.setFocused(false)

            self.viewModel.action(.setArtist(artist))
            self.registerInfoView.artistField.setText(artist.name)

            if let artistId = artist.artistId {
                print("Artist selected, fetch members:", artistId)
                self.viewModel.action(.fetchArtistsList(artistId: artistId))
            }
        }

        if let nav = navigationController {
            nav.pushViewController(searchVC, animated: true)
        } else {
            present(UINavigationController(rootViewController: searchVC), animated: true)
        }
    }
}

// MARK: - delegate Method

extension ProductRegisterViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewModel.action(.didFinishPicking(results))
    }
}
