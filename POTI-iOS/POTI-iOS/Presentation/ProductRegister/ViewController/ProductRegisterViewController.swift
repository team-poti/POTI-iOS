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

final class ProductRegisterViewController: BaseViewController<ProductRegisterViewModel>, NavigationConfigurable {

    func navigationStyle() -> PotiNavigationStyle {
        return .xButton
    }
    
    private let rootView = ProductRegisterView()
    private var imagePickerView: ImagePickerView {
        rootView.imagePickerView
    }

    // MARK: - Life Cycle

    override func loadView() {
        self.view = rootView
    }

    // MARK: - UI Setting

    override func setUI() {

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
}

// MARK: - delegate Method

extension ProductRegisterViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewModel.action(.didFinishPicking(results))
    }
}
