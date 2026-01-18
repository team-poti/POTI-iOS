//
//  DetailBottomSheet.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/18/26.
//


import UIKit

import Combine
import SnapKit
import Then

final class DetailBottomSheet: BaseView {

    // MARK: - Properties

   // private let viewModel: ParticipantManageViewModel
    private var cancellables = Set<AnyCancellable>()
    var onSelectCompletion: ((Int) -> Void)?

    // MARK: - UI Components

    private let backgroundView = UIView()
    private let containerView = UIView()
    private let closeButton = UIButton()
    private let firstTextFieldView = DetailTextFieldView()
    private let secondTextFieldView = DetailTextFieldView()
    private let confirmButton = PotiBottomButton()

    // MARK: - Initializer

    init(
        firstTitle: String,
        firstPlaceholder: String,
        secondTitle: String,
        secondPlaceholder: String,
        confirmButtonText: String
    ) {
        super.init(frame: .zero)

        firstTextFieldView.configure(
            title: firstTitle,
            placeholder: firstPlaceholder
        )

        secondTextFieldView.configure(
            title: secondTitle,
            placeholder: secondPlaceholder
        )

        confirmButton.text = confirmButtonText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Methods

    override func setStyle() {
        setAddTarget()

        backgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.6)
        }

        containerView.do {
            $0.backgroundColor = .potiWhite
            $0.layer.cornerRadius = 20
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.clipsToBounds = true
        }

        closeButton.do {
            $0.setImage(.icnX, for: .normal)
        }
        confirmButton.do {
            $0.color = .primaryMain
            $0.isDisabled = true
        }
    }

    override func setUI() {
        addSubviews(backgroundView, containerView)
        containerView.addSubviews(
            closeButton,
            firstTextFieldView,
            secondTextFieldView,
            confirmButton
        )
    }

    override func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(584)
        }

        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().inset(4)
            $0.size.equalTo(48)
        }
        
        firstTextFieldView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        secondTextFieldView.snp.makeConstraints {
            $0.top.equalTo(firstTextFieldView.snp.bottom).offset(28)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        confirmButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(38)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    private func bindViewModel() {
//        Publishers.CombineLatest(viewModel.output.options, viewModel.output.selectedIndex)
//            .receive(on: RunLoop.main)
//            .sink { [weak self] _ in
//                self?.tableView.reloadData()
//                self?.updateTableViewHeight()
//            }
//            .store(in: &cancellables)
//
//        viewModel.output.onSelect
//            .receive(on: RunLoop.main)
//            .sink { [weak self] index in
//                self?.onSelectCompletion?(index)
//                self?.dismiss()
//            }
//            .store(in: &cancellables)
    }

    private func setAddTarget() {
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Methods

    func show(in view: UIView) {
        view.addSubview(self)
        self.snp.makeConstraints { $0.edges.equalToSuperview() }
        containerView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        backgroundView.alpha = 0

        self.layoutIfNeeded()

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.containerView.transform = .identity
            self.backgroundView.alpha = 1
        }
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 500)
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
