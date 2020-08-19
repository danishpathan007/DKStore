//
//  CategoryCollectionViewCell.swift
//  DKStore
//
//  Created by Danish Khan on 19/08/20.
//  Copyright © 2020 Danish Khan. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    func generateCell(_ category:Category){
        nameLabel.text = category.name
        imageView.image = category.image
    }
    
    
}
