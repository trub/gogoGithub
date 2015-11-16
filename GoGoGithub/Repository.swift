//
//  Repository.swift
//  GoGoGithub
//
//  Created by Michael Babiy on 10/22/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import Foundation


class Repository {
    
    let name: String
    let id: Int
    let url: String
    
    init(name: String, id: Int, url: String) {
        self.name = name
        self.id = id
        self.url = url
    }
}