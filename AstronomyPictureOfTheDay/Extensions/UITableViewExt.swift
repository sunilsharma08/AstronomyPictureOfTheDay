//
//  UITableViewExt.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 11/11/22.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(ofType _: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellIdentifier: String = T.defaultReuseIdentifier) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? T
        else { fatalError("Could not dequeue cell with identifier: \(cellIdentifier)") }
        
        return cell
    }
}
