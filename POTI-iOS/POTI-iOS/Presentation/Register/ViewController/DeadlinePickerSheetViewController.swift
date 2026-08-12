//
//  DeadlinePickerSheetViewController.swift
//  POTI-iOS
//
//  Created by soomin on 1/19/26.
//

import UIKit

import SnapKit
import Then

final class DeadlinePickerSheetViewController: UIViewController {

    // MARK: - Properties

    private let onConfirm: (Date) -> Void
    private let onCancel: () -> Void

    // MARK: - UI Components

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

        let today = Calendar.current.startOfDay(for: Date())
        datePicker.minimumDate = today
        datePicker.date = max(initialDate, today)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .potiWhite
        presentationController?.delegate = self
        setStyle()
        setUI()
        setLayout()
    }

    // MARK: - Private Methods

    private func setStyle() {
        datePicker.do {
            $0.datePickerMode = .date
            $0.locale = Locale(identifier: "ko_KR")
            $0.preferredDatePickerStyle = .wheels
        }

        toolbar.do {
            $0.tintColor = .potiBlack

            let appearance = UIToolbarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .potiWhite
            appearance.shadowColor = .clear
            $0.standardAppearance = appearance
            $0.scrollEdgeAppearance = appearance

            let flex = UIBarButtonItem(systemItem: .flexibleSpace)
            let cancel = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(tapCancel))
            let done = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(tapDone))
            $0.items = [cancel, flex, done]
        }
    }

    private func setUI() {
        view.addSubviews(toolbar, datePicker)
    }

    private func setLayout() {
        toolbar.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }

        datePicker.snp.makeConstraints {
            $0.top.equalTo(toolbar.snp.bottom).offset(-8)
            $0.horizontalEdges.bottom.equalToSuperview()
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
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension DeadlinePickerSheetViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onCancel()
    }
}
