//
//  FormFieldViewController.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/15/26.
//

import UIKit

import SnapKit

final class FormFieldDemoViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var dropdownField: FormFieldView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setUI()
        setLayout()
        addFields()
    }

    private func setUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }

    private func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }

    private func addFields() {
        let field = makeDropdown()
        contentView.addSubview(field)

        field.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
}

private extension FormFieldDemoViewController {

    func makeDropdown() -> FormFieldView {
        let view = FormFieldView.dropdown(
            placeholder: "드롭다운 선택",
            options: ["옵션 A", "옵션 B", "옵션 C", "옵션 D", "옵션 E"],
            maxVisibleRows: 3,
            onSelect: { value in
                print("Dropdown selected:", value)
            }
        )

        dropdownField = view
        return view
    }
}

#Preview() {
    FormFieldDemoViewController()
}
