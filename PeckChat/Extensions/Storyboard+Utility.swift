//
//  Storyboard+Utility.swift
//  PeckChat
//
//  Created by Spencer Peck on 2/24/20.
//  Copyright © 2020 Spencer Peck. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    enum PCType: String {
        case main
        case login

        var filename: String {
            return rawValue.capitalized
        }
    }
    
    convenience init(type: PCType, bundle: Bundle? = nil) {
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: PCType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError("Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }

        return initialViewController
    }
}
