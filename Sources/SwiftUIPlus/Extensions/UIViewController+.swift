//
//  UIViewController+.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import UIKit

public extension UIViewController {
    
    /// Root parent of the UIViewController
    var rootParent: UIViewController {
        if let parent = self.parent {
            return parent.rootParent
        }
        else {
            return self
        }
    }
}
