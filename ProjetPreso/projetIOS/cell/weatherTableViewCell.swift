//
//  weatherTableViewCell.swift
//  projetIOS
//
//  Created by Gepir on 26/06/2022.
//

import UIKit

class weatherTableViewCell: UITableViewCell {

    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let indentifer = "weatherTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "weatherTableViewCell", bundle: nil)
    }
    func configure(with model: ForecastDayData){
        // self.lowTempLabel.text = "\(Int(model.mintemp_c)) °"
        // self.highTempLabel.text = "\(Int(model.maxtemp_c)) °"
        let daydata = model.day
        self.lowTempLabel.textAlignment = .center
        self.highTempLabel.textAlignment = .center
        self.lowTempLabel.text = "\(Int(daydata.mintemp_c)) °C"
        self.highTempLabel.text = "\(Int(daydata.maxtemp_c)) °C"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.date_epoch)))
        self.iconImageView.contentMode = .scaleAspectFit
       
        let summary = daydata.condition
        let icon = summary.text.lowercased()
        
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
    }
    
    func getDayForDate(_ date: Date?) -> String {
            guard let inputDate = date else {
                return ""
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Monday
            return formatter.string(from: inputDate)
        }
}
