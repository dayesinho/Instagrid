//
//  DispositionViewConverter.swift
//  Instagrid
//
//  Created by Mac Hack on 11/06/2018.
//  Copyright © 2018 Mac Hack. All rights reserved.
//

import UIKit


/**
 Extension that allows transform an UIView into an UIImage:
 */

public class DispositionViewConverter {
    
    static func convertViewToImage(view: DispositionView) -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
        UIGraphicsEndImageContext()
        return image
    }
}
