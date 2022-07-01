//
//  currentTableViewCell.swift
//  projetIOS
//
//  Created by Gepir on 30/06/2022.
//

import UIKit

class currentTableViewCell: UITableViewCell {
    
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var uvLabel: UILabel!
    @IBOutlet var visibilityLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let indentifer = "currentTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "currentTableViewCell", bundle: nil)
    }
    func configure(with model: ForecastDayData){
        self.sunriseLabel.text = "\(model.astro.sunrise)"
        self.sunsetLabel.text = "\(model.astro.sunset)"
        self.humidityLabel.text = "\(Int(model.day.avghumidity)) %"
        
        self.uvLabel.text = "niveau \(model.day.uv)"
        self.windLabel.text = "\(model.day.maxwind_kph) km/h"
        self.visibilityLabel.text = "\(model.day.avgvis_miles) ms"
    }
    
}
