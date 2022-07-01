//
//  hourlyCollectionViewCell.swift
//  projetIOS
//
//  Created by Gepir on 30/06/2022.
//

import UIKit

class hourlyCollectionViewCell: UICollectionViewCell {
    static let identifier = "hourlyCollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "hourlyCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var hourLabel: UILabel!
    
    func configure(with model:hourData){
        self.tempLabel.text = "\(Int(model.temp_c))°C"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: "Sun")
        
        let icon = model.condition.text.lowercased()
        if icon.contains("cloudy"){
            self.iconImageView.image = UIImage(named: "Cloud")
        }
        else if icon.contains("rain"){
            self.iconImageView.image = UIImage(named: "Rain")
        }
        else if icon.contains("clear"){
            self.iconImageView.image = UIImage(named: "Clear")
        }
        else {
            self.iconImageView.image = UIImage(named: "Sun")
        }
        let hourly = model.time.suffix(5)
        let hour = hourly.prefix(2)
        self.hourLabel.text = "\(hour) h"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
