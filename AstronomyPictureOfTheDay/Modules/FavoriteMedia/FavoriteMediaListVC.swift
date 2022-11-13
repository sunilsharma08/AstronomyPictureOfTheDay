//
//  FavoriteMediaListVC.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import UIKit

class FavoriteMediaListVC: BaseViewController {
    
    @IBOutlet weak var favMediaTableView: UITableView!
    @IBOutlet weak var emptyMsgLabel: UILabel!
    
    let viewModel: FavoriteMediaListVM = FavoriteMediaListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        showEmptyMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    /// Do intial view configuration here
    func configureViews() {
        favMediaTableView.tableFooterView = UIView()
        favMediaTableView.register(ofType: PictureOfTheDayCell.self)
        favMediaTableView.rowHeight = UITableView.automaticDimension
        favMediaTableView.dataSource = self
    }
    
    func loadData() {
        showActivityIndicator()
        viewModel.getFavMedia { status, errorMsg in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.hideActivityIndicator()
                if status {
                    self.hideEmptyMessage()
                    self.favMediaTableView.reloadData()
                } else {
                    if self.viewModel.dataList.isEmpty {
                        self.showEmptyMessage()
                    } else {
                        self.hideEmptyMessage()
                    }
                }
            }
        }
    }
    
    func showEmptyMessage(_ message: String? = nil) {
        if let message = message {
            self.emptyMsgLabel.text = message
        } else {
            self.emptyMsgLabel.text = "Favorite astronomy picture".localized
        }
        self.emptyMsgLabel.isHidden = false
        self.favMediaTableView.isHidden = true
    }
    
    func hideEmptyMessage() {
        self.emptyMsgLabel.isHidden = true
        self.favMediaTableView.isHidden = false
    }
    
    /// Update UI when favorite buttton is pressed
    func favoriteButtonPressed(indexPath: IndexPath, cell: PictureOfTheDayCell) {
        
        guard viewModel.dataList.count > indexPath.row
        else { return }
        
        let mediaInfo = viewModel.dataList[indexPath.row]
        self.viewModel.deleteFavorite(mediaInfo: mediaInfo)
        self.favMediaTableView.deleteRows(at: [indexPath], with: .automatic)
        self.favMediaTableView.reloadData()
        if viewModel.dataList.isEmpty {
            showEmptyMessage()
        }
    }
}

// MARK: TableView DataSource

extension FavoriteMediaListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.dataList[indexPath.row]
        
        let cell: PictureOfTheDayCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configureViews(data: data, indexPath: indexPath)
        cell.favSelection = { (indexPath, mediaInfoCell) in
            self.favoriteButtonPressed(indexPath: indexPath, cell: mediaInfoCell)
        }
        return cell
    }
}
