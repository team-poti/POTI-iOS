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

final class ProductRegisterViewController: UIViewController {
    // MARK: - State
    private var selectedImages: [UIImage] = [] {
        didSet {
            imagePickerView.setImages(selectedImages)
        }
    }

    // MARK: - Constants
    private let maxCount = 5

    // MARK: - UI
    private let imagePickerView = ImagePickerView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(imagePickerView)
        imagePickerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(CGFloat.dynamicH(90))
        }

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

        imagePickerView.setImages(selectedImages)
    }

    // MARK: - Private
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images
        config.selectionLimit = max(0, maxCount - selectedImages.count) // 남은 개수만큼

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate

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
