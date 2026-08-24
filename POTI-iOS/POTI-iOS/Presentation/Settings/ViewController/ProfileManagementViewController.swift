//
//  ProfileManagementViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/17/26.
//

import UIKit
import PhotosUI

import Combine

final class ProfileManagementViewController: BaseViewController<SettingsViewModel>, NavigationConfigurable {
    private let rootView = ProfileManagementView()

    func navigationStyle() -> PotiNavigationStyle { .backDefault("내 프로필 관리") }

    override func loadView() { view = rootView }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.action(.fetchProfile)
    }

    override func bindViewModel() {
        viewModel.output.profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.configure($0) }
            .store(in: &cancellables)

        viewModel.output.error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.presentUploadFailureAlert(message: message)
            }
            .store(in: &cancellables)
    }

    override func addTarget() {
        rootView.editImageButton.addTarget(self, action: #selector(editImageTapped), for: .touchUpInside)
    }

    @objc private func editImageTapped() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func presentUploadFailureAlert(message: String) {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(
            title: "프로필 사진을 변경하지 못했어요",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension ProfileManagementViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let self, let image = object as? UIImage else { return }

            DispatchQueue.main.async {
                self.rootView.setProfileImage(image)
                guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
                self.viewModel.action(
                    .updateProfileImage(
                        nickname: self.rootView.nickname,
                        imageData: imageData
                    )
                )
            }
        }
    }
}
