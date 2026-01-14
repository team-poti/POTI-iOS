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
}
