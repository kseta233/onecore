//
//  CurrencyInputType.swift
//  ONECore
//
//  Created by Sofyan Fradenza Adi on 28/04/20.
//

import UIKit

open class CurrencyInputType: InputType {
    private var textField: TextField
    private var prefix: String
    open var identifier: InputTypeIdentifier = .currency
    open func render() {}
    open func resetValue() {}
    open func didBeginEditingHandler(_ textField: TextField) {}
    open func didEndEditingHandler(_ textField: TextField) {}

    public init(textField: TextField, prefix: String, defaultValue: Double? = nil) {
        self.textField = textField
        self.textField.keyboardType = .numberPad
        self.prefix = prefix
        self.textField.text = getDisplayText(
            originalText: defaultValue == nil
                ? DefaultValue.emptyString
                : String(defaultValue ?? DefaultValue.emptyDouble)
        )
    }

    open func getValue() -> AnyObject {
        guard let text = textField.text else { return 0 as AnyObject }
        return (Double(text.digits) ?? 0) as AnyObject
    }

    open func getDisplayText() -> String {
        return getDisplayText(originalText: textField.getText())
    }

    open func shouldChangeCharactersIn(range: NSRange, replacementString string: String) -> Bool {
        if range.location < prefix.count { return false }
        if range.location == prefix.count && string == String(DefaultValue.emptyInt) {
            return false
        }
        if textField.text == prefix && string == DefaultValue.emptyString {
            return false
        }
        return true
    }

    open func didChangeHandler(_ textField: TextField) {
        textField.text = getDisplayText()
    }

    open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action != #selector(UIResponderStandardEditActions.paste(_:))
    }

    private func getDisplayText(originalText: String) -> String {
        return String(format: "%@%@", prefix, originalText.withThousandSeparator())
    }
}