//
//  GiphyCollectionViewController.swift
//  Giphy
//
//  Created by Colin Teahan on 5/11/17.
//  Copyright © 2017 Colin Teahan. All rights reserved.
//

import UIKit

final class GiphyCollectionViewController : UICollectionViewController {
    
    // Array to hold our trending Giphy Img objects
    fileprivate var images:[Img?] = [Img?]()
    
    // Dictionary to cache loaded images for each row
    fileprivate var imageCache = [IndexPath:UIImage]()
    
    // Resuse identifier for the GiphyCells
    fileprivate let reuseIdentifier = "GiphyCell"
    
    // Load giphy image data when view is first loaded
    override func viewDidLoad() {
        
        // Async operation queue to download data in background
        let loadGiphy = DispatchQueue(label: "GiphyDataQueue")
        
        loadGiphy.sync {
            
            images = Img.trending() // Set images to trending giphys data
            
            self.loadView() // Reload collection view
        }
    }
}



// Collection view methods
extension GiphyCollectionViewController {
    
    // Returns number of sections in the collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Return the number of items to display in collection view from images arary
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // Returns the cooresponding cell for each item in the collection view
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Set each cell as our custom GiphyCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! GiphyCell
        
        // Load image from cache if it exists
        if imageCache[indexPath] != nil {
            
            cell.imageView.image = imageCache[indexPath]
        
        // Asyc download image from web and cache for later
        } else if let image = images[indexPath.item] {
            
            image.loadImage() { (UIImage) in
                
                cell.imageView.image = UIImage // Set image to view
                
                imageCache[indexPath] = UIImage // Add image to cache
            }
            
        }
        
        return cell
    }
}
