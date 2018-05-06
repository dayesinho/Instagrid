//
//  ViewController.swift
//  Instagrid P5
//
//  Created by Mac Hack on 11/04/2018.
//  Copyright © 2018 Mac Hack. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var dispositionView: DispositionView!
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    }
    @IBAction func firstPattern() {
        
        dispositionView.square2.isHidden = true
        dispositionView.square4.isHidden = false
    }
    
    @IBAction func secondPattern() {
        
        dispositionView.square2.isHidden = false
        dispositionView.square4.isHidden = true
        
    }
    
    @IBAction func thirdPattern() {
        dispositionView.square2.isHidden = false
        dispositionView.square4.isHidden = false
    }
    @IBAction func choosePicture1(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Select a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction)  in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction)  in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imageView1 = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


