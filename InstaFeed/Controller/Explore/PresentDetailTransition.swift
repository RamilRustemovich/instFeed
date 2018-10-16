//
//  PresentDetailTransition.swift
//  InstaFeed
//
//  Created by Ramil on 13/10/2018.
//  Copyright © 2018 Ramil. All rights reserved.
//

import UIKit

class PresentDetailTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let detail = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        
        detail.view.alpha = 0
        
        var frame = containerView.bounds
        frame.origin.y += 20
        frame.size.height -= 20
        detail.view.frame = frame
        containerView.addSubview(detail.view)
        
        UIView.animate(withDuration: 0.5, animations: {
            detail.view.alpha = 1
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
}

