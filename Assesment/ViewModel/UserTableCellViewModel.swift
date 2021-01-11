//
//  UserTableCellViewModel.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 10/01/21.
//

import Foundation

class UserTableCellViewModel {
    
    let imageUrl: String?
    let title: String?
    let userDetailDescription: String?
    
    init(imageUrl: String, title: String, userDetailDescription: String) {
        self.imageUrl = imageUrl
        self.title = title
        self.userDetailDescription = userDetailDescription
    }
}
