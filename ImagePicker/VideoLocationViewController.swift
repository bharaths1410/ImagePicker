//
//  VideoLocationViewController.swift
//  ImagePicker
//
//  Created by Bharath Sirangi on 4/4/17.
//  Copyright © 2017 Bharath Sirangi. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import AVFoundation
import AVKit


class VideoLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var videoURL: URL?
    
        @IBAction func showVideo(_ sender: Any) {
            
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        self.present(imagePicker, animated: true) {
            
        }
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        videoURL = info[UIImagePickerControllerMediaURL] as! URL?
        
        let aSelector = #selector(image(image:didFinishSavingWithError:contextInfo:))
        //image:didFinishSavingWithError:contextInfo
        let videoPath = videoURL?.relativePath
        
//        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoPath!))
//        {
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath!, self, aSelector, nil)
//        }
        
        picker.dismiss(animated: true) {
//            if let videoURL = self.videoURL{
//                let player = AVPlayer(url: videoURL as URL)
//                
//                let playerViewController = AVPlayerViewController()
//                playerViewController.player = player
//                
//                self.present(playerViewController, animated: true) {
//                    playerViewController.player!.play()
//                }
//            }

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func image(image: UIImage, didFinishSavingWithError: NSErrorPointer, contextInfo:UnsafeRawPointer)       {
        print("Successfully saved photo, will make request to update asset metadata")
        
        // fetch the most recent image asset:
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.video, options: fetchOptions)
        
        // get the asset we want to modify from results:
        let lastImageAsset = fetchResult.lastObject
        
        // create CLLocation from lat/long coords:
        // (could fetch from LocationManager if needed)
        let myLatitude = 38.8893
        let myLongitude = -77.0502
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
