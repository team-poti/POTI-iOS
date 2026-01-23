//
//  DeadlinePickerSheetViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/22/26.
//

import UIKit

import SnapKit
import Then

final class DeadlinePickerSheetViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

    // MARK: - Properties

    private let onConfirm: (Date) -> Void
    private let onCancel: () -> Void

    private let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko_KR")
        $0.preferredDatePickerStyle = .wheels
        $0.minimumDate = Date()
    }

    private let toolbar = UIToolbar().then {
        $0.tintColor = .potiBlack
    }

    // MARK: - Initializer

    init(
        initialDate: Date,
        onConfirm: @escaping (Date) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        super.init(nibName: nil, bundle: nil)
        
        datePicker.date = initialDate
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
        toolbar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }

        datePicker.snp.makeConstraints {
            $0.top.equalTo(toolbar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
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
