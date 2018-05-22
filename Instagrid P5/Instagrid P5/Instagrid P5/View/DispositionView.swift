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
    
    
    func displayPattern1() {
        squareTR.isHidden = true
        squareBR.isHidden = false
    }
    
    func displayPattern2() {
        squareTR.isHidden = false
        squareBR.isHidden = true
    }
    
    func displayPattern3() {
        squareTR.isHidden = false
        squareBR.isHidden = false
    }
}
