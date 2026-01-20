//
//  UITableView2+.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/20/26.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
}
