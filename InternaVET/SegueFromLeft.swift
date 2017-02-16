//
//  SegueFromLeft.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import QuartzCore

class SegueFromLeft: UIStoryboardSegue {
    
    override func perform() {
        let sourceCtrlr: UIViewController = self.source
        let targetCtrlr: UIViewController = self.destination
        let transition: CATransition = CATransition()
        let timeFunc: CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        sourceCtrlr.navigationController!.view.layer.add(transition, forKey: kCATransition)
        sourceCtrlr.navigationController!.pushViewController(targetCtrlr, animated: false)
    }
    
}
