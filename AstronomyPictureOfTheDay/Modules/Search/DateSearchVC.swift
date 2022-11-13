//
//  DateSearchVC.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 10/11/22.
//

import UIKit

protocol DateSearchDelegate: AnyObject {
    func searchSelected(date: Date)
    func cancelSearch()
}

extension DateSearchDelegate {
    func cancelSearch() { }
}

class DateSearchVC: BaseViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    weak var searchDelegate: DateSearchDelegate?
    var viewModel: DateSearchVM = DateSearchVM()
    
    class var instance: DateSearchVC? {
        let storyboard = UIStoryboard(name: "DateSearchVC", bundle: Bundle.main)
        if let vc = storyboard.instantiateViewController(withIdentifier: String(describing: DateSearchVC.self)) as? DateSearchVC {
            return vc
        } else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    /// Do intial view configuration here
    func configureViews() {
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.datePicker.maximumDate = viewModel.datePickerMaxDate()
        self.datePicker.minimumDate = viewModel.datePickerMinDate()
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 5
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.searchDelegate?.cancelSearch()
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            self.searchDelegate?.searchSelected(date: self.datePicker.date)
        }
    }
}
