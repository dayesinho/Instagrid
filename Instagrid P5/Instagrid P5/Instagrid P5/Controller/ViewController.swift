//
//  ViewController.swift
//  Instagrid P5
//
//  Created by Mac Hack on 11/04/2018.
//  Copyright © 2018 Mac Hack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    /**
     IBOutlet:
    */
    @IBOutlet weak var dispositionView: DispositionView!
    @IBOutlet var patternButtons: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    
    /**
     Var:
    */
    
    let imagePickerController = UIImagePickerController()
    var tag: Int?
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    var imageViewInserted: UIImageView!
   
    /**
     viewDidLoad:
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispositionView.displayMiddlePattern()
        imagePickerControllerBehaviors()
        setUpSwipeDirection()
        dispositionView.sortOutletCollections()
        setBehaviors()
    
        
    }
    
    /**
     IBAction to select the 3 patterns available on the app:
    */
    
    @IBAction private func patternButton(_ sender: UIButton) {
        unselectPatternButtons()
        patternButtons[sender.tag].isSelected = true
        
        switch sender.tag {
        case 0:
            dispositionView.displayLeftPattern()
        case 1:
            dispositionView.displayMiddlePattern()
        case 2:
            dispositionView.displayRightPattern()
        default:
            break
        }
    }
    
    /**
     Func that allows only select one pattern:
    */
    
    private func unselectPatternButtons() {
        
        patternButtons.forEach { (button) in
            button.isSelected = false
        }
    }

    /**
     Func to select the camera or the photo library:
    */
    
    @IBAction private func choosePicture(_ sender: UIButton) {
        
        tag = sender.tag
        showImageSourceMenu()
    }
    
    
    private func setBehaviors() {
        
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector (handleShareAction))
        
        guard let swipeGestureRecognizer = swipeGestureRecognizer else {return}
        dispositionView.addGestureRecognizer(swipeGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector (setUpSwipeDirection), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    /**
     Adding the Delegate to the imagePickerController:
     */
    
    private func imagePickerControllerBehaviors() {
        
        imagePickerController.delegate = self
    }
    
    /**
     Func that permit add the tapGesture on the images choosen by the user
     */
    
    @objc private func displayImageSourceMenu(gesture: UITapGestureRecognizer) {
        
        tag = gesture.view?.tag
        showImageSourceMenu()
    }
    
    /**
    Method that give the possibility to the user to choose the source of the picture that he wants to add:
    */
    
    @objc private func showImageSourceMenu() {
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Select a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction)  in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
            } else {
                self.createAlert(titleText: "Oops...", messageText: "Sorry, the camera is not available on your device.")
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
    
    /**
    Func to create the alert on the camera, if it's not avaiable or not working:
    */
    
    private func createAlert(titleText: String,messageText: String){
        
        let cameraAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        cameraAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            cameraAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    /**
    Animation to move the dispositionView and the stackView when it shared:
    */
    
    @objc private func handleShareAction() {
        
        if swipeGestureRecognizer?.direction == .up {
            UIView.animate(withDuration: 0.8) {
                self.stackView.transform = CGAffineTransform(translationX:0, y: -self.view.frame.height)
                self.dispositionView.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
                self.showActivityController()
            }
        } else {
            UIView.animate(withDuration: 0.8) {
                self.stackView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                self.dispositionView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                self.showActivityController()
            }
        }
    }
    
    /**
    Configure the direction when the device is in landscape mode:
    */
    
     @objc private func setUpSwipeDirection() {
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGestureRecognizer?.direction = .left
        } else {
            swipeGestureRecognizer?.direction = .up
        }
    }

    /**
    Method to set the dispositionView and the stackView in the original position:
    */
    
    private func originalPositionDispositionView() {
        
        UIView.animate(withDuration: 0.8) {
        self.stackView.transform = .identity
        self.dispositionView.transform = .identity
        }
    }
    
    /**
    Method to allow the user share the content/pictures present on the disposition view:
    */
    
     private func showActivityController() {
        
        if dispositionView.isAvailableToShare() {
            guard let pictureToShare = DispositionViewConverter.convertViewToImage(view: dispositionView) else {return}
            
            let activityController = UIActivityViewController(activityItems: [pictureToShare], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
            
            activityController.completionWithItemsHandler = { activity, completed, items, error in
                self.originalPositionDispositionView()
            }
        } else {
            createAlert(titleText: "Caution", messageText: "The grid needs to be completed to share")
            originalPositionDispositionView()
        }
    }
}

/**
 Extension to configure the image picker controller:
*/

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let picturePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        guard let tag = tag else {return}
        
        dispositionView.photoImageViews[tag].image = picturePicked
        dispositionView.plusButtons[tag].isHidden = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (displayImageSourceMenu(gesture:)))
        dispositionView.photoImageViews[tag].addGestureRecognizer(tapGestureRecognizer)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

