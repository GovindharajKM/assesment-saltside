//
//  DetailsViewModel.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 11/01/21.
//

import UIKit

class DetailsViewModel {
    
    let imageUrl: String?
    let title: String?
    let userDetailDescription: String?
    
    init(imageUrl: String, title: String, userDetailDescription: String) {
        self.imageUrl = imageUrl
        self.title = title
        self.userDetailDescription = userDetailDescription
    }

}
