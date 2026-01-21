//
//  DeadlinePickerSheetViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

import UIKit

final class DeadlinePickerSheetViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    // MARK: - Properties

    private let onConfirm: (Date) -> Void
    private let onCancel: () -> Void

    private let datePicker = UIDatePicker()
    private let toolbar = UIToolbar()

    // MARK: - Initializer

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

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .potiWhite

        setUI()
        setLayout()
        presentationController?.delegate = self
    }

    // MARK: - UI

    private func setUI() {
        view.addSubviews(toolbar, datePicker)

        toolbar.tintColor = .potiBlack

        let flex = UIBarButtonItem(systemItem: .flexibleSpace)
        let cancel = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(tapCancel)
        )
        let done = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(tapDone)
        )

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

    // MARK: - Actions

    @objc private func tapCancel() {
        onCancel()
        dismiss(animated: true)
    }

    @objc private func tapDone() {
        onConfirm(datePicker.date)
        dismiss(animated: true)
    }

    // MARK: - Delegate

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onCancel()
    }
}
