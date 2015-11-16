//
//  User.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 11/13/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import Foundation


class User {
    
    let userLogin: String
    let userName: String
    let userEmail: String
    let userURL: String
    let userImageURL: String
    let userFollowers: Int
    let userFollowing: Int
    
    init(userLogin: String, userName: String,  userEmail: String, userURL: String, userImageURL: String, userFollowers: Int, userFollowing: Int) {
        self.userLogin = userLogin
        self.userName = userName
        self.userEmail = userEmail
        self.userURL = userURL
        self.userImageURL = userImageURL
        self.userFollowers = userFollowers
        self.userFollowing = userFollowing
    }
    
}

