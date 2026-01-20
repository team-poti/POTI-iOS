//
//  UITableView+.swift
//  POTI-iOS
//
//  Created by 이서현 on 1/15/26.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
}
