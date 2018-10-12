//
//  InstagramData.swift
//  InstaFeed
//
//  Created by Ramil on 12/10/2018.
//  Copyright © 2018 Ramil. All rights reserved.
//

import UIKit

class InstagramData {
    
    static func imageForPhoto(photoDicionary: AnyObject, size: String, completion: @escaping (_ image: UIImage) -> ()) {
        let urlString = photoDicionary.value(forKeyPath: "images.\(size).url") as! String
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        let request = URLRequest(url: url!)
        let task = session.downloadTask(with: request) { (localFile, response, error) in
            if error == nil {
                if let data = NSData(contentsOf: localFile!),
                    let image = UIImage(data: data as Data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
        task.resume()
        
    }
}
