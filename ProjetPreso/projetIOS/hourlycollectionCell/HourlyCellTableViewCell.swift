//
//  HourlyCellTableViewCell.swift
//  projetIOS
//
//  Created by Gepir on 26/06/2022.
//

import UIKit

class HourlyCellTableViewCell: UITableViewCell, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView : UICollectionView!
    var models = [hourData]()
    override func awakeFromNib() {
        super.awakeFromNib()
        //setup collectionview
        collectionView.register(hourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: hourlyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let indentifer = "HourlyCellTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "HourlyCellTableViewCell", bundle: nil)
    }
    func configure(with models: [hourData]){
        self.models = models
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: hourlyCollectionViewCell.identifier, for: indexPath) as! hourlyCollectionViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
}
