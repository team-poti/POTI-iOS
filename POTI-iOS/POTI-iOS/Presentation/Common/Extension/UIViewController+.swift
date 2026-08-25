//
//  UIViewController+.swift
//  POTI-iOS
//
//  Created by 김나연 on 1/10/26.
//

import UIKit

extension UIViewController {

    /// 키보드 위 화면 터치 시, 키보드 내리기
    func hideKeyboardWhenTappedAround() {
        let tapped = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tapped.cancelsTouchesInView = false
        view.addGestureRecognizer(tapped)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    var totalNavigationBarHeight: CGFloat {
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.size.height ?? 0
        return navigationBarHeight + statusBarHeight
    }
    
    func switchRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let windowScene = view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else { return }
        sceneDelegate.switchRootViewController(to: viewController, animated: animated)
    }
}
