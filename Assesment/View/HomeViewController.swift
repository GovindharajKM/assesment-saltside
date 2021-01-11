//
//  HomeViewController.swift
//  Assesment
//
//  Created by Govindharaj Murugan on 09/01/21.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refreshControl: UIRefreshControl!
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSearchBar()
        self.configureTableView()
        self.setupRefreshController()
        self.initViewModel()
    }
    
    func setUpSearchBar() {
        self.searchBar.backgroundColor = UIColor().getTintColor
        self.searchBar.setTextField(color: .white)
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.backgroundImage = UIImage()
        self.searchBar.delegate = self
    }
    
    func configureTableView() {
        self.tableViewList.dataSource = self
        self.tableViewList.delegate = self
        self.tableViewList.tableFooterView = UIView()
        self.tableViewList.separatorStyle = .none
        self.tableViewList.register(UINib(nibName: UserTableViewCell.cellIdentifier(), bundle: nil), forCellReuseIdentifier: UserTableViewCell.cellIdentifier())
    }
    
    func setupRefreshController() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = .systemPurple
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh_Clicked), for: .valueChanged)
        self.tableViewList.addSubview(self.refreshControl)
    }
    
    @objc func refresh_Clicked() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.refreshControl.endRefreshing()
        }
//        textField?.text = ""
        self.searchBar.getTextField()?.text = "" //self.viewModel.getSearchBarTextField(self.searchBar)
        self.viewModel.initFetch()
    }
    
    private func initViewModel() {

        self.viewModel.reloadTableViewClosure = {
            DispatchQueue.main.async { [weak self] in
                self?.tableViewList.reloadData()
            }
        }

        self.viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    LoadingView.shared.show()
                }else {
                    LoadingView.shared.hide()
                }
            }
        }

        self.viewModel.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
        
        self.viewModel.loadLocalCacheIfHave()
        self.viewModel.initFetch()
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.viewModel.numberOfCells > 0 else {
            return 0
        }
        return self.viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userCell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentifier()) as? UserTableViewCell else {
            return UITableViewCell()
        }
        userCell.setUpCell(self.viewModel.getCellViewModel(at: indexPath))
//        userCell.viewBackground.addDropShadowforTableViewCell()
        return userCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.searchBar.endEditing(true)
        
        let profileview = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        profileview.userDetails = self.viewModel.getDetailsViewModel(at: indexPath)
        self.navigationController?.pushViewController(profileview, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.numberOfCells - 1 && self.searchBar.getTextField()?.text == "" {
            self.viewModel.loadMoreData(self.viewModel.numberOfCells)
        }
    }
}
 

// MARK:- UISearchBarDelegate
extension HomeViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.searchTextDidChange(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
