//
//  PostcodeSearchViewController.swift
//  POTI-iOS
//
//  Created by Neon on 8/24/26.
//

import UIKit
import WebKit

import SnapKit
import Then

final class PostcodeSearchViewController: UIViewController, NavigationConfigurable, NavigationActionHandling {
    private enum Constant {
        static let messageName = "postcode"
    }

    private let onSelect: (String, String) -> Void
    private lazy var messageHandler = WeakPostcodeMessageHandler(delegate: self)
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(messageHandler, name: Constant.messageName)
        return WKWebView(frame: .zero, configuration: configuration)
    }()

    init(onSelect: @escaping (String, String) -> Void) {
        self.onSelect = onSelect
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .potiWhite
        setUI()
        setLayout()
        loadPostcodeSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PotiNavigationBar.configure(
            navigationItem: navigationItem,
            navigationController: navigationController,
            style: navigationStyle(),
            target: self
        )
    }

    func navigationStyle() -> PotiNavigationStyle {
        .backDefault("우편번호 검색")
    }

    @objc func navigationButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    private func setUI() {
        webView.do {
            $0.navigationDelegate = self
            $0.scrollView.contentInsetAdjustmentBehavior = .never
            $0.isOpaque = false
            $0.backgroundColor = .potiWhite
        }
        view.addSubview(webView)
    }

    private func setLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func loadPostcodeSearch() {
        webView.loadHTMLString(Self.html, baseURL: URL(string: "https://postcode.map.daum.net"))
    }
}

extension PostcodeSearchViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation?,
        withError error: Error
    ) {
        presentLoadFailureAlert()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation?, withError error: Error) {
        presentLoadFailureAlert()
    }

    private func presentLoadFailureAlert() {
        guard presentedViewController == nil else { return }
        let alert = UIAlertController(
            title: "주소 검색을 불러오지 못했어요",
            message: "네트워크 연결을 확인한 뒤 다시 시도해 주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension PostcodeSearchViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == Constant.messageName,
              let body = message.body as? [String: Any],
              let postalCode = body["postalCode"] as? String,
              let address = body["address"] as? String else { return }

        onSelect(postalCode, address)
        navigationController?.popViewController(animated: true)
    }
}

private final class WeakPostcodeMessageHandler: NSObject, WKScriptMessageHandler {
    weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

private extension PostcodeSearchViewController {
    static let html = """
    <!doctype html>
    <html lang="ko">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
      <style>
        html, body, #postcode { width: 100%; height: 100%; margin: 0; padding: 0; overflow: hidden; }
      </style>
    </head>
    <body>
      <div id="postcode"></div>
      <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
      <script>
        window.addEventListener('load', function () {
          new daum.Postcode({
            oncomplete: function (data) {
              var address = data.userSelectedType === 'R' ? data.roadAddress : data.jibunAddress;
              window.webkit.messageHandlers.postcode.postMessage({
                postalCode: data.zonecode,
                address: address
              });
            },
            width: '100%',
            height: '100%'
          }).embed(document.getElementById('postcode'), { autoClose: false });
        });
      </script>
    </body>
    </html>
    """
}
