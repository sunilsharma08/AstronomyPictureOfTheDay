//
//  PictureOfTheDayCell.swift
//  AstronomyPictureOfTheDay
//
//  Created by Sunil Sharma on 11/11/22.
//

import UIKit
import Kingfisher

class PictureOfTheDayCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var thumnailImageView: UIImageView!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var indexPath: IndexPath?
    var favSelection: ((IndexPath, PictureOfTheDayCell) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favoriteButton.tintColor = AppColors.favUnselected
    }
    
    func configureViews(data: MediaInfo, indexPath: IndexPath) {
        self.indexPath = indexPath
        titleLabel.text = data.title
        dateLabel.text = data.dateString
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified
        
        let attributedString = NSAttributedString(string: data.explanation ?? "",
                                                  attributes: [
                                                    NSAttributedString.Key.paragraphStyle: paragraphStyle])
        self.explanationLabel.attributedText = attributedString
        
        if data.isFavorite {
            self.favoriteButton.tintColor = AppColors.favSelected
        } else {
            self.favoriteButton.tintColor = AppColors.favUnselected
        }
        
        self.thumnailImageView.kf.indicatorType = .activity
        if let imageUrl = data.media?.thumnailUrl {
            
            KF.url(URL(string: imageUrl))
                .transition(.fade(1))
                .downsampling(size: CGSize(width: 320, height: 200))
                .set(to: thumnailImageView)
        }
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        guard let indexPath = self.indexPath
        else { return }
        
        self.favSelection?(indexPath, self)
    }
    
}
