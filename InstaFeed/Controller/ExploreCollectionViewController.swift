//
//  ExploreCollectionViewController.swift
//  InstaFeed
//
//  Created by Ramil on 10/10/2018.
//  Copyright © 2018 Ramil. All rights reserved.
//

import UIKit

class ExploreCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var accesToken: String!
    private var photoDictionaries = [AnyObject]()
    
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    struct Storyboard {
        static let explorePhotoCell = "ExplorePhotoCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//
//        // Do any additional setup after loading the view.
        
        // configure the collection view
        collectionView?.backgroundColor = .white
        let width = (collectionView!.frame.width - leftAndRightPaddings) / numberOfItemsPerRow
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: width, height: width + heightAdjustment)
        
        authInstagram()
    }
    
    // MARK: Helper methods
    func authInstagram() {
        // check on registration
        let userDefaults = UserDefaults.standard
        if let token = userDefaults.object(forKey: "accesToken") as? String {
            accesToken = token
            print(token)
            print("Already Log In")
            
            // Start dowloading photos
            fetchPhotos()
        } else {
            // MARK: Authorize
            SimpleAuth.authorize("instagram", options: [:]) { [weak self] (responseObject, error) in
                if let response = responseObject as? NSDictionary {
                    let credentials = response["credentials"] as! NSDictionary
                    let accesToken = credentials["token"] as! String
                    self?.accesToken = accesToken
                    
                    userDefaults.set(self?.accesToken, forKey: "accesToken")
                    userDefaults.synchronize()
                    
                    // Start dowloading photos
                    self?.fetchPhotos()
                }
            }
        }
    }
    
    func urlWithSearchText(searchText: String) -> URL {
        let escapedSearchText = searchText.replacingOccurrences(of: " ", with: "")
        let urlString = "https://api.instagram.com/v1/tags/\(escapedSearchText)/media/recent?access_token=" + String(accesToken)
        
        //let urlString3 = "https://api.instagram.com/v1/tags/\(escapedSearchText)/media/recent?access_token=8508776244.51bac4a.21bfffbe80de4fe5a5a4b03d31a1dd56"
        return URL(string: urlString)!
    }
    
    func fetchPhotos() {
        let session = URLSession.shared
        let url: URL
        
        if !(searchBar.text?.isEmpty)! {
            url = urlWithSearchText(searchText: searchBar.text!)
        } else {
            url = urlWithSearchText(searchText: "car")
        }
        
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { [weak self](localFile, response, error) in
            if error == nil {
                let data = NSData(contentsOf: localFile!)
                
                do {
                    let responseDictionary = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [String: Any]
                    self?.photoDictionaries = responseDictionary["data"] as! [AnyObject]
                    print(self?.photoDictionaries ?? "nooooooooooooooo")
                } catch let error {
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
        task.resume()
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDictionaries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.explorePhotoCell, for: indexPath) as! ExplorePhotoCollectionViewCell
        //cell.imageView.image = UIImage(named: "no_image")
        let photoDictionary = photoDictionaries[indexPath.item]
        cell.photo = photoDictionary
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
