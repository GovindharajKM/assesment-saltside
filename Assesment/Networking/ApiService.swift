//
//  ApiService.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 10/01/21.
//

import Foundation
import Alamofire


enum APIError: String, Error {
    case noNetwork = "No Network"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
}

typealias WebServiceCallBack = (_ success : Bool, _ response : Any?, _ error : APIError? ) -> Void

class ApiService {
    
    init() { }
    
    // Fetch all Users ans Search users by keyword
    func fetchAllDetails(_ url: String, complete: @escaping WebServiceCallBack) {
        guard Reachability.isConnectedToNetwork() else {
            complete(false, nil, .noNetwork)
            return
        }
        AF.request(url).validate().responseDecodable(of: [UserDetails].self) { (response) in
            DispatchQueue.main.async {
                guard let users = response.value else {
                    complete(false, nil as AnyObject?, .serverOverload)
                    return
                }
                UserDetailModel().insertAllListToDB(users)
                complete(true, users as AnyObject?, nil)
            }
        }
    }
    
}
