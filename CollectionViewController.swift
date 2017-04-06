//
//  CollectionViewController.swift
//  ImagePicker
//
//  Created by Bharath Sirangi on 4/3/17.
//  Copyright © 2017 Bharath Sirangi. All rights reserved.
//

import UIKit
import Photos

class CollectionViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var collectionView: UICollectionView!
    var imageArray = [UIImage]()
    var assets = PHFetchResult<AnyObject>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        let fetchResult :PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
      
        self.assets = fetchResult as! PHFetchResult<AnyObject>
        
        if fetchResult.count > 0 {
            
            for i in 0..<fetchResult.count {
                
                imageManager.requestImage(for: fetchResult[i] , targetSize: CGSize(width:200, height:200), contentMode: .aspectFill, options: requestOptions, resultHandler: {
                    image, error in
                    
                    self.imageArray.append(image!)
                    
                })
           
            }
            
        }
        else{
            print("There are no photos")
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width/3 - 1
    
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
