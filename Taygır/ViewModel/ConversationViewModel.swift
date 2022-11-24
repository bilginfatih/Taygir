//
//  ConversationViewModel.swift
//  Taygır
//
//  Created by Fatih Bilgin on 24.11.2022.
//

import Foundation

struct ConversationViewModel {
    
    private let conversaiton: Conversation
    
    var profileImageUrl: URL? {
        return URL(string: conversaiton.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversaiton.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversaiton: Conversation) {
        self.conversaiton = conversaiton
    }
}
