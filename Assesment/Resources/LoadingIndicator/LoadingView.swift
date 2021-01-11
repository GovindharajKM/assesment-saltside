//
//  LoadingView.swift
//  CMSTXPusher
//
//  Created by Lemuel on 23/05/19.
//  Copyright © 2019 Impiger Technologies. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

class LoadingView: UIView {
    
    static let shared : LoadingView = LoadingView.getView()
    
    @IBOutlet weak var indicatorBaseView : UIView!
    
    var loadingView : NVActivityIndicatorView!
    var showCount : Int = 0
    
    var type : NVActivityIndicatorType = .lineScale {
        didSet {
            if self.loadingView != nil {
                self.loadingView.type = type
            }
        }
    }
    
    var color : UIColor = UIColor.systemPurple {
        didSet {
            if self.loadingView != nil {
                self.loadingView.color = color
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.frame = UIScreen.main.bounds
        self.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25)
        self.loadingView = NVActivityIndicatorView.init(frame: self.indicatorBaseView.bounds, type: self.type, color: self.color, padding: 0)
        self.loadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.indicatorBaseView.addSubview(self.loadingView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func show() {
        if self.showCount > 0 { return }
        self.showCount +=  1
        DispatchQueue.main.async {
            if let window :UIWindow = UIApplication.shared.keyWindow {                
                self.loadingView.startAnimating()
                window.addSubview(self)
            }
        }
    }
    
    func hide() {
        self.showCount =  max(self.showCount - 1, 0)
        if showCount > 0 { return }
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.removeFromSuperview()
        }
    }
    
    class func getView() -> LoadingView {
        return Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)?[0] as! LoadingView
    }
    
}
