//
//  SingleImageViewController.swift
//  Giphy
//
//  Created by Paradox on 5/18/17.
//  Copyright © 2017 dlabs. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextField: UITextField!
    
    var data:Img?
    var indexPath:IndexPath?
    
    weak var delegate: GiphyCollectionViewController?
    
    @IBAction func updateUrl(sender: AnyObject) {
        if let inputText = myTextField.text {
            data?.didUpdateURL(newText: inputText)
            print("Updated url")
        }
    }
    
    @IBAction func deleteImage() {
        delegate?.deleteGiphy(self.indexPath!)
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImageView.image = data?.image
        myTextField.text = data?.url
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
