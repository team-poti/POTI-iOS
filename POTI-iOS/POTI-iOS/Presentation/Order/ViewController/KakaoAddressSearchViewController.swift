//
//  KakaoAddressSearchViewController.swift
//  POTI-iOS
//
//  Created by soomin on 8/17/26.
//

import UIKit
import WebKit

import SnapKit

final class KakaoAddressSearchViewController: UIViewController, NavigationActionHandling {

    // MARK: - Properties

    var onSelectAddress: ((KakaoAddress) -> Void)?

    private lazy var messageHandler = WeakScriptMessageHandler(delegate: self)
    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(messageHandler, name: "addressSearch")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        return webView
    }()

    // MARK: - Life Cycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setUI()
        setLayout()
        loadAddressSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PotiNavigationBar.configure(navigationItem: navigationItem, navigationController: navigationController,
                                    style: .backDefault("주소 검색"), target: self)
        setNavigationBarBackgroundColor()
    }

    // MARK: - Private Methods

    private func setStyle() {
        view.backgroundColor = .white
    }

    private func setUI() {
        view.addSubview(webView)
    }

    private func setLayout() {
        webView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func loadAddressSearch() {
        webView.loadHTMLString(Self.addressSearchHTML, baseURL: URL(string: "https://postcode.map.kakao.com"))
    }

    private func setNavigationBarBackgroundColor() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController?.view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: - Action

    @objc func navigationButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - WKScriptMessageHandler

extension KakaoAddressSearchViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "addressSearch", let body = message.body as? [String: Any], let type = body["type"] as? String else { return }

        guard type == "selected", let zipcode = body["zipcode"] as? String,
              let address = body["address"] as? String else { return }
        onSelectAddress?(KakaoAddress(zipcode: zipcode, address: address))
    }
}

// MARK: - WeakScriptMessageHandler

private final class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
    private weak var delegate: WKScriptMessageHandler?

    init(delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

// MARK: - HTML

private extension KakaoAddressSearchViewController {
    static let addressSearchHTML = """
    <!doctype html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
        <style>
            * {
                box-sizing: border-box;
            }

            html, body, #address-search {
                width: 100%;
                height: 100%;
                margin: 0;
                padding: 0;
                overflow: hidden;
                background-color: #FFFFFF;
            }

            #address-search iframe {
                display: block;
                border: 0 !important;
            }
        </style>
        <script src="https://t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    </head>
    <body>
        <div id="address-search"></div>
        <script>
            function postMessage(body) {
                window.webkit.messageHandlers.addressSearch.postMessage(body);
            }

            window.onload = function() {
                if (typeof kakao === 'undefined' || typeof kakao.Postcode === 'undefined') {
                    return;
                }

                const container = document.getElementById('address-search');
                const postcode = new kakao.Postcode({
                    oncomplete: function(data) {
                        const address = data.roadAddress || data.jibunAddress;
                        postMessage({ type: 'selected', zipcode: data.zonecode, address: address });
                    },
                    width: '100%',
                    height: '100%'
                });

                postcode.embed(container, { autoClose: false });
            };
        </script>
    </body>
    </html>
    """
}
