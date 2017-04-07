//
//  ViewController.swift
//  ImagePicker
//
//  Created by Bharath Sirangi on 4/3/17.
//  Copyright © 2017 Bharath Sirangi. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var myImage: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func chooseImageAction(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true){
            
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage  {
           
            self.myImage.image = image

            let aSelector = #selector(image(image:didFinishSavingWithError:contextInfo:))
            //image:didFinishSavingWithError:contextInfo
            UIImageWriteToSavedPhotosAlbum(image, self, aSelector, nil)
        }
        picker.dismiss(animated: true) {
            
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    
    
    func image(image: UIImage, didFinishSavingWithError: NSErrorPointer, contextInfo:UnsafeRawPointer)       {
        print("Successfully saved photo, will make request to update asset metadata")
        
        // fetch the most recent image asset:
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        
        // get the asset we want to modify from results:
        let lastImageAsset = fetchResult.lastObject
        
        // create CLLocation from lat/long coords:
        // (could fetch from LocationManager if needed)
        let myLatitude = 28.644800
        let myLongitude =  77.216721
        let coordinate = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        let nowDate = Date()
        // I add some defaults for time/altitude/accuracies:
        let myLocation = CLLocation(coordinate: coordinate, altitude: 0.0, horizontalAccuracy: 1.0, verticalAccuracy: 1.0, timestamp: nowDate)
        
        // make change request:
        PHPhotoLibrary.shared().performChanges({
            
            // modify existing asset:
            let assetChangeRequest = PHAssetChangeRequest(for: lastImageAsset!)
            assetChangeRequest.location = myLocation
            
        }, completionHandler: {
            (success:Bool, error:Error?) -> Void in
            
            if (success) {
                print("Succesfully saved metadata to asset")
                print("location metadata = \(myLocation)")
            } else {
                print("Failed to save metadata to asset with error: \(error!)")
            }
            
        })
    }
    


}

