//
//  ImageResizer.swift
//  Sessionz
//
//  Created by C4Q on 6/19/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func reDrawImage(using size: CGSize) -> UIImage{
        let customImage = self
        //creating image context:
        UIGraphicsBeginImageContext(size)
        customImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let reSizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizedImage!
    }
    
}
