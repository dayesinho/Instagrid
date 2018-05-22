//
//  UIImagePickerController.swift
//  Instagrid
//
//  Created by Mac Hack on 21/05/2018.
//  Copyright © 2018 Mac Hack. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var shouldAutorotate: Bool {return true}
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {return .all}
}
