//
//  DetailsViewController.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 09/01/21.
//

import UIKit
import Alamofire
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtViewDescription: UITextView!
    
    var userDetails: DetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
    }
    
    func updateUI() {
        let url = URL(string: self.userDetails.imageUrl ?? "")
        self.imageViewUser.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
        self.lblTitle.text = self.userDetails.title
        self.txtViewDescription.text = self.userDetails.userDetailDescription
    }
}
