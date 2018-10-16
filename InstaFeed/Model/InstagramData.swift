//
//  InstagramData.swift
//  InstaFeed
//
//  Created by Ramil on 12/10/2018.
//  Copyright © 2018 Ramil. All rights reserved.
//

import UIKit
import SAMCache

class InstagramData {
    
    static func imageForPhoto(photoDicionary: AnyObject, size: String, completion: @escaping (_ image: UIImage) -> ()) {
        
        let photoId = photoDicionary["id"] as! String
        let key = "\(photoId)-\(size)"
        
        if let image = SAMCache.shared().image(forKey: key) {
            completion(image)
        } else {
            let urlString = photoDicionary.value(forKeyPath: "images.\(size).url") as! String
            let url = URL(string: urlString)
            
            let session = URLSession.shared
            let request = URLRequest(url: url!)
            let task = session.downloadTask(with: request) { (localFile, response, error) in
                if error == nil {
                    if let data = NSData(contentsOf: localFile!),
                        let image = UIImage(data: data as Data) {
                        SAMCache.shared().setImage(image, forKey: key)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
