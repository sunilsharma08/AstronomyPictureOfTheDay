//
//  ReusableView.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 11/11/22.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UITableViewCell {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
