//
//  LoginController.swift
//  Taygır
//
//  Created by Fatih Bilgin on 18.11.2022.
//

import UIKit

private let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
private let buttonHeight = textFieldHeight
private let buttonHorizontalMargin = (textFieldHorizontalMargin / 2)
private let buttonImageDimension: CGFloat = 18
private let buttonVerticalMargin = (buttonHeight - buttonImageDimension) / 2
private let buttonWidth = (textFieldHorizontalMargin / 2) + buttonImageDimension
private let critterViewFrame = CGRect(x: 0, y: 0, width: 160, height: 160)
private let textFieldHeight: CGFloat = 37
private let textFieldHorizontalMargin: CGFloat = 16.5
private let textFieldSpacing: CGFloat = 22
private let textFieldTopMargin: CGFloat = 38.8
private let textFieldWidth: CGFloat = 206

protocol AuthenticationControllerProtocol {
    func checkFromStatus()
}

class LoginController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    private let critterView = CritterView(frame: critterViewFrame)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Giriş Yap", for: .normal)
        button.backgroundColor = .taygir
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Henüz kayıt olmadın mı?  ",
                                                 attributes: [.font: UIFont.systemFont(ofSize: 16),
                                                              .foregroundColor: UIColor.text])
        attributedTitle.append(NSAttributedString(string: "Kayıt Ol",
                                                  attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold),
                                                               .foregroundColor: UIColor.black]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = createTextField(text: "Email")
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.keyboardAppearance = .dark
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = createTextField(text: "Şifre")
        textField.isSecureTextEntry = true
        textField.rightView = showHidePasswordButton
        showHidePasswordButton.isHidden = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardAppearance = .dark
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1
        textField.leftViewMode = .always
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var showHidePasswordButton: UIButton = {
            let button = UIButton(type: .custom)
            button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: buttonVerticalMargin, leading: 0, bottom: buttonVerticalMargin, trailing: buttonHorizontalMargin)
            button.frame = buttonFrame
            button.tintColor = .text
            button.setImage(#imageLiteral(resourceName: "Password-show"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "Password-hide"), for: .selected)
            button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            return button
        }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setUpGestures()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        
        critterView.frame = CGRect(x: (scrollView.width-size)/2 - 10,
                                   y: 40,
                                   width: size * (3/2),
                                   height: size * (3/2))
        
        emailTextField.frame = CGRect(x: 60,
                                      y: critterView.bottom+10,
                                      width: scrollView.width-120,
                                      height: 42)
        
        passwordTextField.frame = CGRect(x: 60,
                                         y: emailTextField.bottom+10,
                                         width: scrollView.width-120,
                                         height: 42)
        
        loginButton.frame = CGRect(x: 60,
                                   y: passwordTextField.bottom+40,
                                   width: scrollView.width-120,
                                   height: 42)
    }
    
    // MARK: - Selectors
    
    @objc func handleShowSignUp() {
        let controller = RegistirationController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleLogin() {
        
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        checkFromStatus()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(scrollView)
        scrollView.addSubview(critterView)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor,
                                     bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                     right: view.rightAnchor,
                                     paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - UITextFieldDelegate

        func textFieldDidBeginEditing(_ textField: UITextField) {
            let deadlineTime = DispatchTime.now() + .milliseconds(100)

            if textField == emailTextField {
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                    let fractionComplete = self.fractionComplete(for: textField)
                    self.critterView.startHeadRotation(startAt: fractionComplete)
                    self.passwordDidResignAsFirstResponder()
                }
            }
            else if textField == passwordTextField {
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                    self.critterView.isShy = true
                    self.showHidePasswordButton.isHidden = false
                }
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            }
            else {
                passwordTextField.resignFirstResponder()
                passwordDidResignAsFirstResponder()
            }
            return true
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == emailTextField {
                critterView.stopHeadRotation()
            }
        }

        @objc private func textFieldDidChange(_ textField: UITextField) {
            guard !critterView.isActiveStartAnimating, textField == emailTextField else { return }

            let fractionComplete = self.fractionComplete(for: textField)
            critterView.updateHeadRotation(to: fractionComplete)

            if let text = textField.text {
                critterView.isEcstatic = text.contains("@")
            }
        }

    
    // MARK: - Private

        private func fractionComplete(for textField: UITextField) -> Float {
            guard let text = textField.text, let font = textField.font else { return 0 }
            let textFieldWidth = textField.bounds.width - (2 * textFieldHorizontalMargin)
            return min(Float(text.size(withAttributes: [NSAttributedString.Key.font : font]).width / textFieldWidth), 1)
        }

        private func stopHeadRotation() {
            emailTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            critterView.stopHeadRotation()
            passwordDidResignAsFirstResponder()
        }

        private func passwordDidResignAsFirstResponder() {
            critterView.isPeeking = false
            critterView.isShy = false
            showHidePasswordButton.isHidden = true
            showHidePasswordButton.isSelected = false
            passwordTextField.isSecureTextEntry = true
        }

        private func createTextField(text: String) -> UITextField {
            let view = UITextField(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
            view.backgroundColor = .white
            view.layer.cornerRadius = 4.07
            view.tintColor = .taygir
            view.autocorrectionType = .no
            view.autocapitalizationType = .none
            view.spellCheckingType = .no
            view.delegate = self
            view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

            let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
            view.leftView = UIView(frame: frame)
            view.leftViewMode = .always

            view.rightView = UIView(frame: frame)
            view.rightViewMode = .always

            view.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
            view.textColor = .text

            let attributes: [NSAttributedString.Key : Any] = [
                .foregroundColor: UIColor.disabledText,
                .font : view.font!
            ]

            view.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)

            return view
        }

    
    // MARK: - Gestures

        private func setUpGestures() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(tapGesture)
        }

        @objc private func handleTap() {
            stopHeadRotation()
        }

        // MARK: - Actions

        @objc private func togglePasswordVisibility(_ sender: UIButton) {
            sender.isSelected.toggle()
            let isPasswordVisible = sender.isSelected
            passwordTextField.isSecureTextEntry = !isPasswordVisible
            critterView.isPeeking = isPasswordVisible

            // 🎩✨ Magic to fix cursor position when toggling password visibility
            if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument), let password = passwordTextField.text {
                passwordTextField.replace(textRange, withText: password)
            }
        }
}

extension LoginController: AuthenticationControllerProtocol {
    func checkFromStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .link
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .taygir
        }
    }
}
