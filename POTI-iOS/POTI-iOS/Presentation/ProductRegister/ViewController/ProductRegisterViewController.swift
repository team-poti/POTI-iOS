//
//  ProductRegisterViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit

import PhotosUI
import SnapKit
import Then

final class ProductRegisterViewController: BaseViewController<Void> {

// MARK: - Properties

    private var selectedImages: [UIImage] = [] {
        didSet {
            imagePickerView.setImages(selectedImages)
        }
    }

// MARK: - UI Components

    private let maxCount = 5

    private let imagePickerView = ImagePickerView()

// MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerView.setImages(selectedImages)
    }


// MARK: - Custom Method

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

// MARK: - Action Method

    override func addTarget() {
        imagePickerView.onTapAdd = { [weak self] in
            guard let self else { return }
            guard self.selectedImages.count < self.maxCount else { return }
            self.presentPicker()
        }

        imagePickerView.onTapDelete = { [weak self] index in
            guard let self else { return }
            guard self.selectedImages.indices.contains(index) else { return }
            self.selectedImages.remove(at: index)
        }
    }


// MARK: - Custom Method

    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = max(0, maxCount - selectedImages.count)

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}


// MARK: - delegate Method

extension ProductRegisterViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard !results.isEmpty else { return }

        let group = DispatchGroup()
        var newImages: [UIImage] = []

        for r in results {
            group.enter()
            r.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                defer { group.leave() }
                if let img = object as? UIImage {
                    newImages.append(img)
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            let remaining = self.maxCount - self.selectedImages.count
            self.selectedImages.append(contentsOf: newImages.prefix(remaining))
        }
    }
}

// TODO: - ImagePickerViewModel 분리
