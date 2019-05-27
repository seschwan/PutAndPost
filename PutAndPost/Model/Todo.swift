//
//  Todo.swift
//  PutAndPost
//
//  Created by Seschwan on 5/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import Foundation

struct Todo: Codable {
    var title:       String
    var identifier: String
    
    init(title: String, indentifier: String = UUID().uuidString) { //UUID is something that give a unique string record value. 
        self.title = title
        self.identifier = indentifier
    }
}
