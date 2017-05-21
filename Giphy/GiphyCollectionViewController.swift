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
    fileprivate var dataList:[String?] = [String?]()
    
    fileprivate var dataStore:[String:Img?] = [String:Img?]()
    
    // Resuse identifier for the GiphyCells
    fileprivate let reuseIdentifier = "GiphyCell"
    
    // Load giphy image data when view is first loaded
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear")
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
}



// Collection view methods
extension GiphyCollectionViewController {
    
    @IBAction func reloadData() {
        DispatchQueue.global().async {
            let tempArray = Img.trending(number: 10)
            for newData in tempArray {
                if let key = newData?.url {
                    if self.dataStore[key] == nil {
                        self.dataStore[key] = newData
                        DispatchQueue.main.async { [unowned self] in
                            self.insertDataIntoDataList(newData: newData)
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    func insertDataIntoDataList(newData:Img?) {
        
        self.dataList.append(newData?.url)
        
        self.collectionView?.insertItems(at: [IndexPath(item: self.dataList.count-1, section: 0)])
    }
    
    
    //override func ins
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("\(indexPath)")
        openSelectedImage(indexPath: indexPath)
        
    }
    
    
    func openSelectedImage(indexPath: IndexPath) {
        
        let selectImage = storyboard?.instantiateViewController(withIdentifier: "SingleImage") as! SingleImageViewController
        
        if let key = dataList[indexPath.item] {
            if let data = dataStore[key] {
                selectImage.data = data
                selectImage.indexPath = indexPath
                selectImage.delegate = self
                navigationController?.pushViewController(selectImage, animated: true)
            }
        }
    }
    
    
    func deleteGiphy(_ indexPath:IndexPath) {
        
        print("deleting giphy...")
        
        if let key = dataList[indexPath.item] {
            dataList.remove(at: indexPath.item)
            dataStore.removeValue(forKey: key)
            self.collectionView?.reloadData()
        }
    }
    
    
    // Returns number of sections in the collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Return the number of items to display in collection view from images arary
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    // Returns the cooresponding cell for each item in the collection view
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Set each cell as our custom GiphyCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! GiphyCell
        
        
        cell.imageView.image = nil
        cell.loadingSpinner.isHidden = false
        cell.loadingSpinner.startAnimating()
        
        if let key = dataList[indexPath.item] {
            if let data = dataStore[key] {
                data?.loadImage() { (UIImage) in
                    cell.loadingSpinner.isHidden = true
                    cell.imageView.image = UIImage // Set image to view
                }
            }
        }
        
        return cell
    }
}
