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
    @IBOutlet weak var stackView: UIStackView!
    
    
    // Var:
    
    let imagePickerController = UIImagePickerController()
    var tag: Int?
    var swipeGestureRecognizer: UISwipeGestureRecognizer?
    var imageViewInserted: UIImageView!
    var tapGestureRecognizer: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispositionView.displayMiddlePattern()
        imagePickerControllerBehaviors()
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector (handleShareAction))
        setUpSwipeDirection()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (displayImageSourceMenu(gesture:)))
        dispositionView.sortOutletCollections()
    
        
        guard let swipeGestureRecognizer = swipeGestureRecognizer else {return}
        dispositionView.addGestureRecognizer(swipeGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector (setUpSwipeDirection), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    // IBAction to select the 3 patterns available on the app.
    
    @IBAction func patternButton(_ sender: UIButton) {
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
    
    func unselectPatternButtons() {
        
        patternButtons.forEach { (button) in
            button.isSelected = false
        }
    }

    // Func to select the camera or the photo library:
    
    @IBAction func choosePicture(_ sender: UIButton) {
        
        tag = sender.tag
        showImageSourceMenu()
    }
    
    func imagePickerControllerBehaviors() {
        
        imagePickerController.delegate = self
    }
    
    @objc func displayImageSourceMenu(gesture: UITapGestureRecognizer) {
        
        tag = gesture.view?.tag
        
        showImageSourceMenu()
    }
    
    func showImageSourceMenu() {
        
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
    
    // Func to create the alert on the camera, if it's not avaiable or not working:
    
    func createAlert(titleText: String,messageText: String){
        
        let cameraAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        
        cameraAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        cameraAlert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(cameraAlert, animated: true, completion: nil)
    }
    
    @objc func handleShareAction() {
        
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
    
    @objc func setUpSwipeDirection() {
        
        if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
            swipeGestureRecognizer?.direction = .left
        } else {
            swipeGestureRecognizer?.direction = .up
        }
    }

    func originalPositionDispositionView() {
        
        UIView.animate(withDuration: 0.8) {
        self.stackView.transform = .identity
        self.dispositionView.transform = .identity
        }
    }
    
    func showActivityController() {
        
        let picturesToShare = [UIImagePickerControllerOriginalImage]
        
        let activityController = UIActivityViewController(activityItems: picturesToShare, applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            self.originalPositionDispositionView()
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let picturePicked = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        guard let tag = tag else {return}
        
        dispositionView.photoImageViews[tag].image = picturePicked
        dispositionView.plusButtons[tag].isHidden = true
        guard let tapGestureRecognizer = tapGestureRecognizer else {return}
        dispositionView.photoImageViews[tag].addGestureRecognizer(tapGestureRecognizer)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
