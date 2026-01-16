//
//  FormFieldView+Delegate.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/15/26.
//

import UIKit

extension FormFieldView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        apply(state: .focused)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // ViewModel에서 에러 상태를 내려주는 구조라면 여기서 .normal로만 돌려도 OK
        apply(state: .normal)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        // count(max): 최대 글자수 도달하면 입력 막기 + next 기준 카운트 즉시 반영
        if case .count(let max) = variant {
            let current = textField.text ?? ""
            guard let r = Range(range, in: current) else { return true }
            let next = current.replacingCharacters(in: r, with: string)
            if next.count > max { return false }

            updateCount(current: next.count, max: max)
            onTextChanged?(next)
            return true
        }

        return true
    }
}

extension FormFieldView: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        apply(state: .focused)
        updateTextViewPlaceholderVisibility()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        apply(state: .normal)
        updateTextViewPlaceholderVisibility()
    }

    func textViewDidChange(_ textView: UITextView) {
        updateTextViewPlaceholderVisibility()
        onTextChanged?(getText())
    }
}
