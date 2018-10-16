//
//  DismissDetailTransition.swift
//  InstaFeed
//
//  Created by Ramil on 13/10/2018.
//  Copyright © 2018 Ramil. All rights reserved.
//

import UIKit

class DismissDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let detail = transitionContext.viewController(forKey: .from)!
        
        UIView.animate(withDuration: 0.5, animations: {
            detail.view.alpha = 0
        }) { (finished) in
            detail.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}

