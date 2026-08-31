//
//  ShareBottomSheetViewController.swift
//  POTI-iOS
//
//  Created by soomin on 8/28/26.
//

import UIKit

import KakaoSDKShare
import SnapKit

final class ShareBottomSheetViewController: BaseViewController<ShareBottomSheetViewModel> {

    // MARK: - Properties

    private let rootView = ShareBottomSheetView()

    // MARK: - Initializer

    init(content: ShareBottomSheetContent) {
        super.init(viewModel: ShareBottomSheetViewModel(content: content))

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    // MARK: - Life Cycle

    override func loadView() {
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.preparePresentation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.animatePresentation()
    }

    // MARK: - Custom Methods

    override func addTarget() {
        rootView.onDismiss = { [weak self] in
            self?.dismissBottomSheet()
        }
        rootView.onSelect = { [weak self] option in
            self?.viewModel.action(.select(option))
        }
    }

    override func bindViewModel() {
        viewModel.output.selectedOption
            .sink { [weak self] option in
                self?.handleShareOption(option)
            }
            .store(in: &cancellables)
    }

    // MARK: - Private Methods

    private func dismissBottomSheet(completion: (() -> Void)? = nil) {
        rootView.animateDismissal { [weak self] in
            guard let self else { return }
            self.dismiss(animated: false, completion: completion)
        }
    }

    private func handleShareOption(_ option: ShareOption) {
        switch option {
        case .link:
            UIPasteboard.general.url = viewModel.content.deepLink
            showLinkCopyToast()
        case .kakaoTalk:
            shareToKakaoTalk()
        case .x:
            shareToX()
        case .system:
            shareWithSystem()
        }
    }

    private func shareToKakaoTalk() {
        guard let templateID = try? AppConfig.kakaoShareTemplateID() else { return }
        let templateArgs = viewModel.content.templateArgs
        dismissBottomSheet {
            ShareApi.shared.shareCustom(templateId: templateID, templateArgs: templateArgs) { sharingResult, error in
                if let error {
                    PotiLogger.error(error)
                    return
                }
                guard let sharingResult else { return }
                DispatchQueue.main.async {
                    UIApplication.shared.open(sharingResult.url)
                }
            }
        }
    }

    private func showLinkCopyToast() {
        let presenter = presentingViewController
        dismissBottomSheet {
            guard let presenter else { return }

            let toastView = LinkCopyToastView()
            toastView.isUserInteractionEnabled = false
            presenter.view.addSubview(toastView)
            toastView.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.bottom.equalTo(presenter.view.safeAreaLayoutGuide).inset(24)
                $0.height.equalTo(48)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                toastView.removeFromSuperview()
            }
        }
    }

    private func shareToX() {
        let text = viewModel.content.xShareText
        dismissBottomSheet {
            var components = URLComponents(string: "https://twitter.com/intent/tweet")
            components?.queryItems = [URLQueryItem(name: "text", value: text)]
            guard let shareURL = components?.url else { return }
            UIApplication.shared.open(shareURL)
        }
    }

    private func shareWithSystem() {
        let activityViewController = UIActivityViewController(activityItems: [viewModel.content.title, viewModel.content.deepLink], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0)
        present(activityViewController, animated: true)
    }
}
