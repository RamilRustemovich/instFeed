//
//  ExplorePhotoCollectionViewCell.swift
//  InstaFeed
//
//  Created by Ramil on 10/10/2018.
//  Copyright © 2018 Ramil. All rights reserved.
//

import UIKit

class ExplorePhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesOfCount: UILabel!
    
    var photo: AnyObject! {
        didSet {
            InstagramData.imageForPhoto(photoDicionary: photo, size: "thumbnail") { [weak self] (image) in
                self?.imageView.image = image
            }
        }
    }
    
}
