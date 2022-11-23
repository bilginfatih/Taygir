//
//  RegistirationViewModel.swift
//  Taygır
//
//  Created by Fatih Bilgin on 23.11.2022.
//

import Foundation

struct RegistirationViewModel: AuthenticationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
            && username?.isEmpty == false
    }
}
