//
//  ProductRegisterViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import Combine
import PhotosUI

final class ProductRegisterViewController: BaseViewController<ProductRegisterViewModel>, NavigationConfigurable {

    func navigationStyle() -> PotiNavigationStyle {
        .xButton
    }

    // MARK: - Properties

    private let rootView = ProductRegisterView()

    private var imagePickerView: ImagePickerView {
        rootView.imagePickerView
    }
    private var registerInfoView: RegisterInfoView {
        rootView.registerInfoView
    }
    private var registerMemberView: RegisterMemberView? {
        findRegisterMemberView(in: rootView)
    }
    private var noticeView: RegisterNoticeView {
        rootView.registerNoticeView
    }
    private var currentImages: [UIImage] = []


    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBarController = self.tabBarController as? PotiTabBar {
            tabBarController.tabBar.isHidden = false
        }
    }

    // MARK: - UI Setting

    override func setUI() {
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
        
        registerInfoView.onTapDeadlineField = { [weak self] in
            guard let self else { return }
            self.registerInfoView.deadlineField.setFocused(true)
            self.presentDeadlineBottomSheet()
        }

        registerMemberView?.onMembersChanged = { [weak self] members in
            self?.viewModel.action(.setMembers(members))
        }
    }

    override func setLayout() { }


    // MARK: - Custom Method

    override func bindViewModel() {
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
                    self.registerMemberView?.showEditedEmptyError(message: message)
                } else {
                    self.registerMemberView?.hideEditedEmptyError()
                }
            }
            .store(in: &cancellables)
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

        let memberPrices = registerMemberView?.collectPrices() ?? [:]
        let draft = registerInfoView.collectDraft()
        viewModel.action(.submit(info: draft, memberPrices: memberPrices))
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
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date)
    }

    // MARK: - Deadline Bottom Sheet

    private final class DeadlinePickerSheetViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
        
        private let onConfirm: (Date) -> Void
        private let onCancel: () -> Void
        
        
        private let datePicker = UIDatePicker()
        private let toolbar = UIToolbar()
                
        init(
            initialDate: Date,
            onConfirm: @escaping (Date) -> Void,
            onCancel: @escaping () -> Void
        ) {
            self.onConfirm = onConfirm
            self.onCancel = onCancel
            super.init(nibName: nil, bundle: nil)
            
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ko_KR")
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.date = initialDate
            datePicker.minimumDate = Date()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .potiWhite
            
            setUI()
            setLayout()
            presentationController?.delegate = self
        }
        
        private func setUI() {
            view.addSubviews(toolbar, datePicker)
            
            toolbar.tintColor = .potiBlack
            
            let flex = UIBarButtonItem(systemItem: .flexibleSpace)
            let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapCancel))
            let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(tapDone))
            toolbar.items = [cancel, flex, done]
        }
        
        private func setLayout() {
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                toolbar.topAnchor.constraint(equalTo: view.topAnchor),
                toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                toolbar.heightAnchor.constraint(equalToConstant: 44),
                
                datePicker.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
                datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                datePicker.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        @objc private func tapCancel() {
            onCancel()
            dismiss(animated: true)
        }
        
        @objc private func tapDone() {
            onConfirm(datePicker.date)
            dismiss(animated: true)
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            onCancel()
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
