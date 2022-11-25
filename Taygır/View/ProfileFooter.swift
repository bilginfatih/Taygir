//
//  ProfileFooter.swift
//  Taygır
//
//  Created by Fatih Bilgin on 25.11.2022.
//

import UIKit

protocol ProfileFooterDelegate: class {
    func handlerLogout()
}

class ProfileFooter: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileFooterDelegate?
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Çıkış", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .link
        button.layer.cornerRadius =  5
        button.addTarget(self, action: #selector(handlerLogout), for: .touchUpInside )
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left: leftAnchor, right: rightAnchor,
                            paddingLeft: 32, paddingRight: 32)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handlerLogout() {
        delegate?.handlerLogout()
    }
}
