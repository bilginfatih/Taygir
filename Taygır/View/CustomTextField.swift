//
//  CustomTextField.swift
//  Taygır
//
//  Created by Fatih Bilgin on 21.11.2022.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        borderStyle = .none
        font = UIFont.systemFont(ofSize: 16)
        textColor = .text
        keyboardAppearance = .dark
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor : UIColor.text])
        autocorrectionType = .no
        autocapitalizationType = .none
        spellCheckingType = .no
        delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
