//
//  ImgClass.swift
//  Giphy
//
//  Created by Colin Teahan on 5/11/17.
//  Copyright © 2017 Colin Teahan. All rights reserved.
//

import Foundation
import UIKit

class Img {
    
    // Instance Variables
    var url:String
    var height:Int?
    var width:Int?
    var size:Int?
    
    // Giphy API trending url with key and limit of 10
    private static let api = "http://api.giphy.com/v1/stickers/trending?api_key=dc6zaTOxFJmzC&limit=10"
    
    // Class initializer that takes a dictionary of the Giphy image data
    public init?(data:[String: Any]) {
        
        // Parse json data into cooresponding img data
        guard let images = data["images"] as? [String: Any],
        let original = images["original"] as? [String: Any],
            let height = original["height"] as? String,
            let width = original["width"] as? String,
            let size = original["size"] as? String,
            let url = original["url"] as? String else {
                print("error initializing object")
                return nil
        }
        
        // Set class variables to data
        self.height = Int(height);
        self.width = Int(width);
        self.size = Int(size);
        self.url = url;
    }
    
    // Instance method for asynchroneous loading of image
    public func loadImage(completion: (UIImage) -> Void) {
        
        // Download images in background operation queues
        let queue = DispatchQueue(label:"ImageQueue")
        queue.sync {
            do {
                
                // Try loading image from url
                if let url = URL(string: self.url) {
                    
                    let imageData =  try Data(contentsOf: url)
                    
                    if let myImage = UIImage(data: imageData) {
                        
                        completion(myImage) // Return image on completion

                    }
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    
    // Public class method for loading trending images
    public static func trending() -> [Img?] {
        var output = [Img?]();
        do {
            // Try converting api string to url (might fail due to key)
            guard let url = URL(string:Img.api) else {
                print("failed parsing url")
                return output
            }
            
            // Try loading data and parsing to JSON
            let requestData = try Data(contentsOf:url);
            let json = try JSONSerialization.jsonObject(with: requestData) as? [String: Any]
            if let array = json?["data"] as? [[String: Any]] {
                
                // Fill trending array with Img objects
                for item in array {
                    output.append(Img(data: item))
                }
            }
        } catch {
            print("Failed parsing json: \(error)")
        }
        return output
    }
}

