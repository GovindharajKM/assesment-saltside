//
//  HomeViewModel.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 10/01/21.
//

import Foundation
import UIKit

class HomeViewModel {
    
    let url = "https://gist.githubusercontent.com/ashwini9241/6e0f26312ddc1e502e9d280806eed8bc/raw/7fab0cf3177f17ec4acd6a2092fc7c0f6bba9e1f/saltside-json-data"
    
    var apiService: ApiService = { return ApiService()}()
    
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var showAlertClosure: (()->())?
    
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    lazy var arrTempDataSource = [UserDetails]()
    
    private var arrActiveDataSource: [UserDetails] = [UserDetails]() {
        didSet {
            self.arrSearchDataSource.removeAll()
            var arrViewModel = [UserTableCellViewModel]()
            for user in self.arrActiveDataSource {
                arrViewModel.append(self.createCellViewModel(user: user))
            }
            self.arrUserCellModel = arrViewModel
        }
    }
    
    private var arrSearchDataSource: [UserDetails] = [UserDetails]() {
        didSet {
            var arrViewModel = [UserTableCellViewModel]()
            for user in self.arrSearchDataSource {
                arrViewModel.append(self.createCellViewModel(user: user))
            }
            self.arrUserCellModel = arrViewModel
        }
    }
    
    private func createCellViewModel(user: UserDetails) -> UserTableCellViewModel {
        return UserTableCellViewModel(imageUrl: user.image, title: user.title, userDetailDescription: user.userDetailDescription)
    }
    
    private var arrUserCellModel: [UserTableCellViewModel] = [UserTableCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    // NUmber of tableview cell should be appear
    var numberOfCells: Int {
        return self.arrUserCellModel.count
    }
    
    // Get cellview Details
    func getCellViewModel(at indexPath: IndexPath ) -> UserTableCellViewModel {
        return arrUserCellModel[indexPath.row]
    }
    
    // Get Profile View Details
    func getDetailsViewModel(at indexpath: IndexPath) -> DetailsViewModel {
        
        if self.arrSearchDataSource.count > 0 {
            let data = self.arrSearchDataSource[indexpath.row]
            return DetailsViewModel(imageUrl: data.image, title: data.title, userDetailDescription: data.userDetailDescription)
        }
        let data = self.arrActiveDataSource[indexpath.row]
        return DetailsViewModel(imageUrl: data.image, title: data.title, userDetailDescription: data.userDetailDescription)
        
    }
    
    func loadLocalCacheIfHave() {
        self.loadMoreData(0)
    }
    
    func loadMoreData(_ offset: Int) {
        let newData = UserDetailModel().getLimitedEntryFromDB(offset)
        if offset == 0 {
            self.arrActiveDataSource = newData
        } else {
            self.arrActiveDataSource += newData
        }
    }
    
    // MARK:-  API request
    func initFetch() {
        self.isLoading = true
        self.apiService.fetchAllDetails(url) { [weak self] (success, userList, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.loadMoreData(0)
            }
        }
    }
}


// MARK:- Search Functionalities
extension HomeViewModel {
    
    func searchTextDidChange(_ searchText: String) {
        if searchText == "" {
            self.arrActiveDataSource = self.arrTempDataSource
        } else {
            self.arrTempDataSource = self.arrActiveDataSource
            let arrStoredData = UserDetailModel().fetchAllListFromDB()
            let foundArray = arrStoredData.filter({$0.title.lowercased().contains(searchText.lowercased())})
            self.arrSearchDataSource = foundArray
        }
    }
 
}
