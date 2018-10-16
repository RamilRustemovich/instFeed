//
//  DetailPhotoViewController.swift
//  InstaFeed
//
//  Created by Ramil on 13/10/2018.
//  Copyright © 2018 Ramil. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    var photo: NSDictionary?
    var imageView: UIImageView?
    var animator: UIDynamicAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()

//        imageView = UIImageView()
//        view = imageView
//        imageView?.image = UIImage(named: "no_image")

        view.backgroundColor = UIColor(white: 1, alpha: 0.9)
        imageView = UIImageView(frame: CGRect(x: 0, y: -320, width: view.bounds.size.width, height: view.bounds.size.width))
        imageView?.contentMode = .scaleAspectFit
        view.addSubview(imageView!)
        
        if let photoDictionary = photo {
            InstagramData.imageForPhoto(photoDicionary: photoDictionary, size: "standard_resolution", completion: { (image) in
                self.imageView?.image = image
            })
        }
        
        // for close VC
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let snap = UISnapBehavior(item: imageView!, snapTo: view.center)
        animator?.addBehavior(snap)
    }
    
    @objc func close() {
        animator?.removeAllBehaviors()
        
        let snap = UISnapBehavior(item: imageView!, snapTo: CGPoint(x: view.bounds.midX, y: view.bounds.maxY + 180))
        animator?.addBehavior(snap)
        
        dismiss(animated: true, completion: nil)
    }
}






