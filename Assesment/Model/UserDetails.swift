//
//  UserDetails.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 09/01/21.
//

import Foundation

struct UserDetails: Decodable {
    
    var image = ""
    var userDetailDescription = ""
    var title = ""
    
    enum CodingKeys: String, CodingKey {
        case image
        case userDetailDescription = "description"
        case title
    }
}

//typealias UserDetails = [UserDetail]
