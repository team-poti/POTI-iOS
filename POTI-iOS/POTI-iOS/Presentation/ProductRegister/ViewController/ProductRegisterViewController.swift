//
//  ProductRegisterViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import Combine
import PhotosUI
import SnapKit
import Then

final class ProductRegisterViewController: BaseViewController<ProductRegisterViewModel> {

    // MARK: - UI Components

    private let imagePickerView = ImagePickerView()

    // MARK: - Initializer

    override init(viewModel: ProductRegisterViewModel = .init()) {
        super.init(viewModel: viewModel)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - UI Setting

    override func setUI() {
        view.addSubview(imagePickerView)
    }

    override func setLayout() {
        imagePickerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(90)
        }
    }

    // MARK: - Custom Method

    override func bindViewModel() {
        viewModel.imagePickerViewModel.output.images
            .receive(on: RunLoop.main)
            .sink { [weak self] images in
                self?.imagePickerView.setImages(images)
            }
            .store(in: &cancellables)

        viewModel.imagePickerViewModel.output.requestPicker
            .receive(on: RunLoop.main)
            .sink { [weak self] remainingLimit in
                self?.presentPicker(selectionLimit: remainingLimit)
            }
            .store(in: &cancellables)
    }

    // MARK: - Action Method

    override func addTarget() {
        imagePickerView.onTapAdd = { [weak self] in
            self?.viewModel.imagePickerViewModel.action(.tapAdd)
        }

        imagePickerView.onTapDelete = { [weak self] index in
            self?.viewModel.imagePickerViewModel.action(.tapDelete(index))
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
}


    // MARK: - delegate Method

extension ProductRegisterViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewModel.imagePickerViewModel.action(.didFinishPicking(results))
    }
}
