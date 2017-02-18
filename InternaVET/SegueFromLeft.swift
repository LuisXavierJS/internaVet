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
        destination.view.frame.setX(x: 0-destination.view.frame.width)
        if let window = UIApplication.shared.keyWindow{
            window.insertSubview(destination.view, aboveSubview: source.view)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.destination.view.frame = self.source.view.frame
        }) { (_) in
            self.destination.modalPresentationStyle = .overFullScreen
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}

class UnwindSegueFromLeft: UIStoryboardSegue {
    override func perform() {
        source.view.frame.setX(x: 0)
        UIView.animate(withDuration: 0.5, animations: {
            self.source.view.frame.setX(x: 0 - self.source.view.frame.width)
        }) { (_) in
            self.source.dismiss(animated: false, completion: nil)
        }
    }
}
