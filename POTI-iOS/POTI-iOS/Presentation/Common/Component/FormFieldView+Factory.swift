//
//  FormFieldView+Factory.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/15/26.
//

import UIKit

extension FormFieldView {

    convenience init(
        variant: FormFieldVariant,
        placeholder: String? = nil,
        onTapField: (() -> Void)? = nil,
        onTextChanged: ((String) -> Void)? = nil
    ) {
        self.init(frame: .zero)
        configure(variant: variant, placeholder: placeholder)
        self.onTapField = onTapField
        self.onTextChanged = onTextChanged
    }

    static func dropdown(
        placeholder: String,
        options: [String] = [],
        maxVisibleRows: Int = 3,
        onTapField: (() -> Void)? = nil,
        onSelect: ((String) -> Void)? = nil
    ) -> FormFieldView {
        let view = FormFieldView(
            variant: .dropdown,
            placeholder: placeholder,
            onTapField: onTapField,
            onTextChanged: nil
        )

        view.setOptions(options, maxVisibleRows: maxVisibleRows)
        view.onSelectOption = onSelect
        return view
    }

    static func searchNavigate(
        placeholder: String,
        onTapField: (() -> Void)? = nil
    ) -> FormFieldView {
        FormFieldView(
            variant: .search(mode: .navigate),
            placeholder: placeholder,
            onTapField: onTapField,
            onTextChanged: nil
        )
    }

    static func searchSuggest(
        placeholder: String,
        maxVisibleRows: Int = 3,
        onQueryChanged: ((String) -> Void)? = nil,
        onSelect: ((String) -> Void)? = nil
    ) -> FormFieldView {
        let view = FormFieldView(
            variant: .search(mode: .suggest),
            placeholder: placeholder,
            onTapField: nil,
            onTextChanged: onQueryChanged
        )

        view.setOptions([], maxVisibleRows: maxVisibleRows)
        view.onSelectOption = onSelect
        return view
    }

    static func count(
        placeholder: String,
        max: Int,
        onTextChanged: ((String) -> Void)? = nil
    ) -> FormFieldView {
        FormFieldView(
            variant: .count(max: max),
            placeholder: placeholder,
            onTapField: nil,
            onTextChanged: onTextChanged
        )
    }

    static func short(
        placeholder: String,
        onTextChanged: ((String) -> Void)? = nil
    ) -> FormFieldView {
        FormFieldView(
            variant: .short,
            placeholder: placeholder,
            onTapField: nil,
            onTextChanged: onTextChanged
        )
    }

    static func shortSuggest(
        placeholder: String,
        maxVisibleRows: Int = 3,
        onQueryChanged: ((String) -> Void)? = nil,
        onSelect: ((String) -> Void)? = nil
    ) -> FormFieldView {
        let view = FormFieldView(
            variant: .short,
            placeholder: placeholder,
            onTapField: nil,
            onTextChanged: onQueryChanged
        )

        view.setOptions([], maxVisibleRows: maxVisibleRows)
        view.onSelectOption = onSelect
        return view
    }

    static func long(
        placeholder: String,
        onTextChanged: ((String) -> Void)? = nil
    ) -> FormFieldView {
        FormFieldView(
            variant: .long,
            placeholder: placeholder,
            onTapField: nil,
            onTextChanged: onTextChanged
        )
    }
}
