//
//  UserTableViewCell.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 09/01/21.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    
    var viewModel: UserTableCellViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewBackground.layer.borderWidth = 0.5
        self.viewBackground.layer.borderColor = UIColor.lightGray.cgColor
        self.viewBackground.layer.cornerRadius = 5
        
        self.lblTitle.accessibilityIdentifier = "lblTitle"
        self.viewBackground.accessibilityIdentifier = "viewBackground"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell(_ viewModel: UserTableCellViewModel) {
        let url = URL(string: viewModel.imageUrl ?? "")
        self.imageViewUser.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
        
        self.lblTitle.text = viewModel.title
        self.lblDescription.text = viewModel.userDetailDescription
    }
    
    
    
}
