//
//  MyPageHistoryContentView.swift
//  POTI-iOS
//
//  Created by neon on 1/20/26.
//

import UIKit

import SnapKit
import Then

final class MyPageHistoryContentView: BaseView {
    
    // MARK: - UI Components
    
    let scrollView = UIScrollView()
    let ongoingTableView = UITableView()
    let completedTableView = UITableView()
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        
        scrollView.do {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.bounces = false
        }
        
        [ongoingTableView, completedTableView].forEach {
            $0.separatorStyle = .none
            $0.rowHeight = .dynamicH(97)
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
            $0.register(MyPageHistoryCell.self, forCellReuseIdentifier: "MyPageHistoryCell")
        }
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubviews(ongoingTableView, completedTableView)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        ongoingTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(self.snp.width)
            $0.height.equalTo(scrollView)
        }
        
        completedTableView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(ongoingTableView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(self.snp.width)
            $0.height.equalTo(scrollView)
        }
    }
}
