//
//  Session.swift
//  SecondVkClient
//
//  Created by Ilona Skerberga on 20/08/2021.
//

import Foundation

class Session {
    private init() {}
    static let instance = Session()
    
    var token = "" // storage of a token in VK
    var userId = 0 // storing VK user ID
}
