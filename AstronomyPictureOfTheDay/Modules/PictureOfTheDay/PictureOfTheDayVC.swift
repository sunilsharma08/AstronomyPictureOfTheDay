//
//  PictureOfTheDayVC.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import UIKit

class PictureOfTheDayVC: BaseViewController {
    
    @IBOutlet weak var potdTableView: UITableView!
    @IBOutlet weak var emptyMsgLabel: UILabel!
    
    let viewModel: PictureOfTheDayVM = PictureOfTheDayVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        showEmptyMessage()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.updateFavoriteFlag()
        self.potdTableView.reloadData()
    }
    
    /// Do intial view configuration here
    func configureViews() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonClicked))
        self.emptyMsgLabel.text = "Lets explore the universe".localized
        potdTableView.tableFooterView = UIView()
        potdTableView.register(ofType: PictureOfTheDayCell.self)
        potdTableView.rowHeight = UITableView.automaticDimension
        potdTableView.dataSource = self
    }
    
    func loadData() {
        self.showActivityIndicator()
        self.viewModel.getPictureOfTheDay { status, errorMsg in
            self.updateView(status: status, errorMsg: errorMsg)
        }
    }
    
    /// Search astronomy picture for the given date
    func search(date: Date) {
        showActivityIndicator()
        viewModel.search(date: date) { status, errorMsg in
            self.updateView(status: status, errorMsg: errorMsg)
        }
    }
    
    /**
     Update UI based on `status`, also display error message if present irrespective of `status`
     - parameter status: `true` if operation was successful else `false`.
     - parameter errorMsg: Message to display on alert view.
     */
    func updateView(status: Bool, errorMsg: String?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hideActivityIndicator()
            if status {
                self.hideEmptyMessage()
                self.potdTableView.reloadData()
            } else {
                self.showEmptyMessage()
            }
            if let errorMessage = errorMsg {
                self.showMessage(message: errorMessage)
            }
        }
    }
    
    /// Show DateSearch screen
    @objc func searchButtonClicked() {
        if let searchVC = DateSearchVC.instance {
            searchVC.modalPresentationStyle = .overCurrentContext
            searchVC.searchDelegate = self
            self.present(searchVC, animated: true, completion: nil)
        }
    }
    
    /// Update UI when favorite buttton is pressed
    func favoriteButtonPressed(indexPath: IndexPath, cell: PictureOfTheDayCell) {
        
        let mediaInfo = viewModel.dataList[indexPath.row]
        
        if mediaInfo.isFavorite == true {
            mediaInfo.isFavorite = false
            cell.favoriteButton.tintColor = AppColors.favUnselected
            self.viewModel.deleteFavorite(mediaInfo: mediaInfo)
        } else {
            mediaInfo.isFavorite = true
            cell.favoriteButton.tintColor = AppColors.favSelected
            self.viewModel.saveFavorite(mediaInfo: mediaInfo)
        }
    }

    func showEmptyMessage() {
        self.emptyMsgLabel.isHidden = false
        self.potdTableView.isHidden = true
    }
    
    func hideEmptyMessage() {
        self.emptyMsgLabel.isHidden = true
        self.potdTableView.isHidden = false
    }
}

// MARK: TableView DataSource

extension PictureOfTheDayVC: UITableViewDataSource {
    
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

// MARK: DateSearch Delegate

extension PictureOfTheDayVC: DateSearchDelegate {
    
    func searchSelected(date: Date) {
        viewModel.clearData()
        potdTableView.reloadData()
        search(date: date)
    }
}


