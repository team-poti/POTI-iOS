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
        guard let window = view.window ?? UIApplication.shared.windows.first else {
            PotiLogger.error(NSError(domain: "Window not found", code: -1))
            return
        }
        
        if animated {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = viewController
                }
            )
        } else {
            window.rootViewController = viewController
        }
        
        window.makeKeyAndVisible()
    }
}
