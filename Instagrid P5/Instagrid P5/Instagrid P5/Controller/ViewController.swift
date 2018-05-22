//
//  ViewController.swift
//  Instagrid P5
//
//  Created by Mac Hack on 11/04/2018.
//  Copyright © 2018 Mac Hack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // IBOutlet:
    
    @IBOutlet weak var dispositionView: DispositionView!
    
    @IBOutlet var patternButtons: [UIButton]!
    
    
    // Var:
    
    let imagePickerController = UIImagePickerController()
    var tag: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispositionView.displayPattern2()
        imagePickerControllerBehaviors()
    }
    
    // IBAction to select the 3 patterns available on the app.
    
    @IBAction func patternButton(_ sender: UIButton) {
        unselectPatternButtons()
        patternButtons[sender.tag].isSelected = true
        
        switch sender.tag {
        case 0:
            dispositionView.displayPattern1()
        case 1:
            dispositionView.displayPattern2()
        case 2:
            dispositionView.displayPattern3()
        default:
            break
        }
    }
    
    func unselectPatternButtons() {
        
        patternButtons.forEach { (button) in
            button.isSelected = false
        }
    }

    // Func to select the camera or the photo library:
    
    @IBAction func choosePicture(_ sender: UIButton) {
        
        tag = sender.tag
        displayImageSourceMenu()
    }
    
    func imagePickerControllerBehaviors() {
        
        imagePickerController.delegate = self
    }
    
    func displayImageSourceMenu() {
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Select a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction)  in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
            } else {
                self.createAlertCamera(titleText: "Oops...", messageText: "Sorry, the camera is not available on your device.")
            }
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction)  in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // Func to create the alert on the camera, if it's not avaiable or not working:
    
    func createAlertCamera(titleText: String,messageText: String){
        
        let cameraAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        cameraAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            cameraAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    // IBAction that allows use the swipe option + UIActivtyController to share:

    @IBAction func swipeToShareOption(_ sender: Any) {
    
        let activityController = UIActivityViewController(activityItems: [UIImagePickerControllerOriginalImage, dispositionView], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        }

//            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
//            swipeUp.direction = UISwipeGestureRecognizerDirection.up
//            self.view.addGestureRecognizer(swipeUp)
//
//    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
//
//    switch swipe.direction.rawValue {
//    case 0:
//        print("test")
//    case 1:
//        print("test2")
//    default:
//        break
//    }
//    }
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let picturePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        guard let tag = tag else {return}
        
        dispositionView.photoImageViews[tag].image = picturePicked
        dispositionView.plusButtons[tag].isHidden = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(modifyPicturePicked(_:)))
        dispositionView.photoImageViews[tag].addGestureRecognizer(tapGestureRecognizer)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func modifyPicturePicked(_ sender: UITapGestureRecognizer) {
        displayImageSourceMenu()
    }
}
