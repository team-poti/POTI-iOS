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
    
    private let rootView = ProductRegisterView()

    private var imagePickerView: ImagePickerView {
        rootView.imagePickerView
    }

    private var registerInfoView: RegisterInfoView {
        rootView.registerInfoView
    }

    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
    }

    // MARK: - UI Setting

    override func setUI() {
        registerInfoView.onTapDeadlineField = { [weak self] in
            self?.presentDeadlineBottomSheet()
        }
    }

    override func setLayout() {

    }

    // MARK: - Custom Method

    override func bindViewModel() {
        viewModel.output.images
            .receive(on: RunLoop.main)
            .sink { [weak self] images in
                self?.imagePickerView.setImages(images)
            }
            .store(in: &cancellables)

        viewModel.output.requestPicker
            .receive(on: RunLoop.main)
            .sink { [weak self] remainingLimit in
                self?.presentPicker(selectionLimit: remainingLimit)
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
        let sheetVC = DeadlinePickerSheetViewController(initialDate: Date()) { [weak self] date in
            guard let self else { return }
            self.registerInfoView.deadlineField.setText(Self.format(date))
            // self.viewModel.action(.deadlineSelected(date))
        }

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

    private final class DeadlinePickerSheetViewController: UIViewController {

        // MARK: - Properties

        private let onConfirm: (Date) -> Void

        // MARK: - UI Components

        private let datePicker = UIDatePicker()
        private let toolbar = UIToolbar()

        // MARK: - Life Cycle

        init(initialDate: Date, onConfirm: @escaping (Date) -> Void) {
            self.onConfirm = onConfirm
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
        }

        // MARK: - Custom Method

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

        // MARK: - Action Method

        @objc private func tapCancel() {
            dismiss(animated: true)
        }

        @objc private func tapDone() {
            onConfirm(datePicker.date)
            dismiss(animated: true)
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
