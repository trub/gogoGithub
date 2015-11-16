//
//  User.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 11/13/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var profileImageUrl: String
    
    init(name: String, profileImageUrl: String) {
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
    
}