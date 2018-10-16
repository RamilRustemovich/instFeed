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
        
        // configure the search bar
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
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
    
    func urlWithSearchText(searchText: String) -> URL? {
        let escapedSearchText = searchText.replacingOccurrences(of: " ", with: "")
        let urlString = "https://api.instagram.com/v1/tags/\(escapedSearchText)/media/recent?access_token=" + String(accesToken)
        
        //let urlString3 = "https://api.instagram.com/v1/tags/\(escapedSearchText)/media/recent?access_token=8508776244.51bac4a.21bfffbe80de4fe5a5a4b03d31a1dd56"
        return URL(string: urlString)
    }
    
    func fetchPhotos() {
        let session = URLSession.shared
        let url: URL
        
        if !(searchBar.text?.isEmpty)! {
            if let url2 = urlWithSearchText(searchText: searchBar.text!) {
                url = url2
            } else {
                url = urlWithSearchText(searchText: "")! }
                //url = urlWithSearchText(searchText: searchBar.text!) - это как в видео, просто сразу код
        } else {
            url = urlWithSearchText(searchText: "car")!
        }
        
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { [weak self](localFile, response, error) in
            if error == nil {
                let data = NSData(contentsOf: localFile!)
                
                do {
                    let responseDictionary = try JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments) as! [String: Any]
                    self?.photoDictionaries = responseDictionary["data"] as! [AnyObject]
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
        //cell.imageView.image = UIImage(named: "no_image") а если не будет картинки??
        let photoDictionary = photoDictionaries[indexPath.item]
        cell.photo = photoDictionary
        
        if let likes = photoDictionary.value(forKeyPath: "likes.count") {
            cell.likes = String(describing: likes)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photoDictionaries[indexPath.row] as! NSDictionary
        
        let viewController = DetailPhotoViewController()
        viewController.modalPresentationStyle = .custom
        
        viewController.transitioningDelegate = self
        
        viewController.photo = photo
        present(viewController, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension ExploreCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty)! {
            searchBar.resignFirstResponder()
            fetchPhotos()
        }
    }
}

// UIViewControllerTransitioningDelegate
extension ExploreCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentDetailTransition()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissDetailTransition()
    }
}









