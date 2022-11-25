//
//  ProfileViewModel.swift
//  Taygır
//
//  Created by Fatih Bilgin on 25.11.2022.
//

import Foundation

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings
    
    
    var description: String {
        switch self {
        case .accountInfo: return "Üyelik Hakkında"
        case .settings: return "Ayarlar"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
}
