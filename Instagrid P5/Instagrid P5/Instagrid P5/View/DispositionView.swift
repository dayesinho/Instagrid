//
//  DispositionView.swift
//  Instagrid
//
//  Created by Mac Hack on 26/04/2018.
//  Copyright © 2018 Mac Hack. All rights reserved.
//

import UIKit

class DispositionView: UIView {

    // IBOutlet for the UIView, UIImageView and the buttons
    
    @IBOutlet weak var squareTR: UIView!
    @IBOutlet weak var squareBR: UIView!

    @IBOutlet var photoImageViews : [UIImageView]!
    
    @IBOutlet var plusButtons : [UIButton]!
    
    
    func displayLeftPattern() {
        squareTR.isHidden = true
        squareBR.isHidden = false
    }
    
    func displayMiddlePattern() {
        squareTR.isHidden = false
        squareBR.isHidden = true
    }
    
    func displayRightPattern() {
        squareTR.isHidden = false
        squareBR.isHidden = false
    }
    
    func sortOutletCollections() {
        photoImageViews.sort(by: {$0.tag < $1.tag})
        plusButtons.sort(by: {$0.tag < $1.tag})
    }
}
