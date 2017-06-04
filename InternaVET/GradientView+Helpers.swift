//
//  GradientView+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 04/06/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import EZYGradientView

extension EZYGradientView{
    class func backgroundGradientView(frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        let gradientView = EZYGradientView()
        gradientView.frame = frame
        gradientView.firstColor = UIColor.darkGreen
        gradientView.secondColor = UIColor.clear
        gradientView.angleº = 185
        gradientView.colorRatio = 0.35
        gradientView.fadeIntensity = 1
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.7
        
        view.addSubview(gradientView)
        
        let gradientView2 = EZYGradientView()
        gradientView2.frame = frame
        gradientView2.firstColor = UIColor.mediumGreen
        gradientView2.secondColor = UIColor.clear
        gradientView2.angleº = 285
        gradientView2.colorRatio = 0.35
        gradientView2.fadeIntensity = 1
        gradientView2.isBlur = true
        gradientView2.blurOpacity = 0.7
        
        view.addSubview(gradientView2)
        
        let gradientView3 = EZYGradientView()
        gradientView3.frame = frame
        gradientView3.firstColor = UIColor.lightGreen
        gradientView3.secondColor = UIColor.clear
        gradientView3.angleº = 0
        gradientView3.colorRatio = 0.35
        gradientView3.fadeIntensity = 1
        gradientView3.isBlur = true
        gradientView3.blurOpacity = 0.7
        
        view.addSubview(gradientView3)
        return view
    }
}
