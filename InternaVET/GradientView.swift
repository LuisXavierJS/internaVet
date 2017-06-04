//
//  GradientView.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 04/06/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

/*
 The MIT License (MIT)
 
 Copyright (c) 2015 Max Konovalov
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

// MARK: - Gradient Generator

public enum GradientType: Int {
    case linear
    case radial
    case conical
    case bilinear
}

open class MKGradientGenerator {
    
    open class func gradientImage(type: GradientType, size: CGSize, colors: [CGColor], colors2: [CGColor]? = nil, locations: [Float]? = nil, locations2: [Float]? = nil, startPoint: CGPoint? = nil, endPoint: CGPoint? = nil, startPoint2: CGPoint? = nil, endPoint2: CGPoint? = nil, scale: CGFloat? = nil) -> CGImage {
        let w = Int(size.width * (scale ?? UIScreen.main.scale))
        let h = Int(size.height * (scale ?? UIScreen.main.scale))
        let bitsPerComponent: Int = MemoryLayout<UInt8>.size * 8
        let bytesPerPixel: Int = bitsPerComponent * 4 / 8
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var data = [RGBA]()
        
        for y in 0..<h {
            for x in 0..<w {
                let c = pixelDataForGradient(type, colors: [colors, colors2], locations: [locations, locations2], startPoints: [startPoint, startPoint2], endPoints: [endPoint, endPoint2], point: CGPoint(x: x, y: y), size: CGSize(width: w, height: h))
                data.append(c)
            }
        }
        
        let ctx = CGContext(data: &data, width: w, height: h, bitsPerComponent: bitsPerComponent, bytesPerRow: w * bytesPerPixel, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let img = ctx?.makeImage()!
        return img!
    }
    
    fileprivate class func pixelDataForGradient(_ gradientType: GradientType, colors: [[CGColor]?], locations: [[Float]?], startPoints: [CGPoint?], endPoints: [CGPoint?], point: CGPoint, size: CGSize) -> RGBA {
        assert(colors.count > 0)
        
        var colors = colors
        var locations = locations
        var startPoints = startPoints
        var endPoints = endPoints
        
        if gradientType == .bilinear && colors.count == 1 {
            colors.append([UIColor.clear.cgColor])
        }
        
        for (index, colorArray) in colors.enumerated() {
            if gradientType != .bilinear && index > 0 {
                continue
            }
            if colorArray == nil {
                colors[index] = [UIColor.clear.cgColor]
            }
            if locations.count <= index {
                locations.append(uniformLocationsWithCount(colorArray!.count))
            } else if locations[index] == nil {
                locations[index] = uniformLocationsWithCount(colorArray!.count)
            }
            if startPoints.count <= index {
                startPoints.append(nil)
            }
            if endPoints.count <= index {
                endPoints.append(nil)
            }
        }
        
        
        switch gradientType {
        case .linear:
            let g0 = startPoints[0] ?? CGPoint(x: 0.5, y: 0.0)
            let g1 = endPoints[0] ?? CGPoint(x: 0.5, y: 1.0)
            let t = linearGradientStop(point, size, g0, g1)
            return interpolatedColor(t, colors[0]!, locations[0]!)
        case .radial:
            let g0 = startPoints[0] ?? CGPoint(x: 0.5, y: 0.5)
            let g1 = endPoints[0] ?? CGPoint(x: 1.0, y: 0.5)
            let t = radialGradientStop(point, size, g0, g1)
            return interpolatedColor(t, colors[0]!, locations[0]!)
        case .conical:
            let g0 = startPoints[0] ?? CGPoint(x: 0.5, y: 0.5)
            let g1 = endPoints[0] ?? CGPoint(x: 1.0, y: 0.5)
            let t = conicalGradientStop(point, size, g0, g1)
            return interpolatedColor(t, colors[0]!, locations[0]!)
        case .bilinear:
            let g0x = startPoints[0] ?? CGPoint(x: 0.0, y: 0.5)
            let g1x = endPoints[0] ?? CGPoint(x: 1.0, y: 0.5)
            let tx = linearGradientStop(point, size, g0x, g1x)
            let g0y = startPoints[1] ?? CGPoint(x: 0.5, y: 0.0)
            let g1y = endPoints[1] ?? CGPoint(x: 0.5, y: 1.0)
            let ty = linearGradientStop(point, size, g0y, g1y)
            let c1 = interpolatedColor(tx, colors[0]!, locations[0]!)
            let c2 = interpolatedColor(tx, colors[1]!, locations[1]!)
            let c = interpolatedColor(ty, [c1.cgColor, c2.cgColor], [0.0, 1.0])
            return c
        }
    }
    
    fileprivate class func uniformLocationsWithCount(_ count: Int) -> [Float] {
        var locations = [Float]()
        for i in 0..<count {
            locations.append(Float(i)/Float(count-1))
        }
        return locations
    }
    
    fileprivate class func linearGradientStop(_ point: CGPoint, _ size: CGSize, _ g0: CGPoint, _ g1: CGPoint) -> Float {
        let s = CGPoint(x: size.width * (g1.x - g0.x), y: size.height * (g1.y - g0.y))
        let p = CGPoint(x: point.x - size.width * g0.x, y: point.y - size.height * g0.y)
        let t = (p.x * s.x + p.y * s.y) / (s.x * s.x + s.y * s.y)
        return Float(t)
    }
    
    fileprivate class func radialGradientStop(_ point: CGPoint, _ size: CGSize, _ g0: CGPoint, _ g1: CGPoint) -> Float {
        let c = CGPoint(x: size.width * g0.x, y: size.height * g0.y)
        let s = CGPoint(x: size.width * (g1.x - g0.x), y: size.height * (g1.y - g0.y))
        let d = sqrt(s.x * s.x + s.y * s.y)
        let p = CGPoint(x: point.x - c.x, y: point.y - c.y)
        let r = sqrt(p.x * p.x + p.y * p.y)
        let t = r / d
        return Float(t)
    }
    
    fileprivate class func conicalGradientStop(_ point: CGPoint, _ size: CGSize, _ g0: CGPoint, _ g1: CGPoint) -> Float {
        let c = CGPoint(x: size.width * g0.x, y: size.height * g0.y)
        let s = CGPoint(x: size.width * (g1.x - g0.x), y: size.height * (g1.y - g0.y))
        let q = atan2(s.y, s.x)
        let p = CGPoint(x: point.x - c.x, y: point.y - c.y)
        var a = atan2(p.y, p.x) - q
        if a < 0 {
            a += 2 * π
        }
        let t = a / (2 * π)
        return Float(t)
    }
    
    fileprivate class func interpolatedColor(_ t: Float, _ colors: [CGColor], _ locations: [Float]) -> RGBA {
        assert(!colors.isEmpty)
        assert(colors.count == locations.count)
        
        var p0: Float = 0
        var p1: Float = 1
        
        var c0 = colors.first!
        var c1 = colors.last!
        
        for (i, v) in locations.enumerated() {
            if v > p0 && t >= v {
                p0 = v
                c0 = colors[i]
            }
            if v < p1 && t <= v {
                p1 = v
                c1 = colors[i]
            }
        }
        
        let p: Float
        if p0 == p1 {
            p = 0
        } else {
            p = lerp(t, inRange: p0...p1, outRange: 0...1)
        }
        
        let color0 = RGBA(c0)
        let color1 = RGBA(c1)
        
        return color0.interpolateTo(color1, p)
    }
    
}


// MARK: - Color Data

fileprivate struct RGBA {
    var r: UInt8
    var g: UInt8
    var b: UInt8
    var a: UInt8
}

extension RGBA: Equatable {
}

fileprivate func ==(lhs: RGBA, rhs: RGBA) -> Bool {
    return (lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b && lhs.a == rhs.a)
}

extension RGBA {
    
    fileprivate init() {
        self.init(r: 0, g: 0, b: 0, a: 0)
    }
    
    fileprivate init(_ hex: Int) {
        let r = UInt8((hex >> 16) & 0xff)
        let g = UInt8((hex >> 08) & 0xff)
        let b = UInt8((hex >> 00) & 0xff)
        self.init(r: r, g: g, b: b, a: 0xff)
    }
    
    fileprivate init(_ color: UIColor) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        self.init(r: UInt8(r * 0xff), g: UInt8(g * 0xff), b: UInt8(b * 0xff), a: UInt8(a * 0xff))
    }
    
    fileprivate init(_ color: CGColor) {
        let c = color.components?.map { min(max($0, 0.0), 1.0) }
        switch color.numberOfComponents {
        case 2:
            self.init(r: UInt8((c?[0])! * 0xff), g: UInt8((c?[0])! * 0xff), b: UInt8((c?[0])! * 0xff), a: UInt8((c?[1])! * 0xff))
        case 4:
            self.init(r: UInt8((c?[0])! * 0xff), g: UInt8((c?[1])! * 0xff), b: UInt8((c?[2])! * 0xff), a: UInt8((c?[3])! * 0xff))
        default:
            self.init()
        }
    }
    
    fileprivate var uiColor: UIColor {
        return UIColor(red: CGFloat(r)/0xff, green: CGFloat(g)/0xff, blue: CGFloat(b)/0xff, alpha: CGFloat(a)/0xff)
    }
    
    fileprivate var cgColor: CGColor {
        return self.uiColor.cgColor
    }
    
    fileprivate func interpolateTo(_ color: RGBA, _ t: Float) -> RGBA {
        let r = lerp(t, self.r, color.r)
        let g = lerp(t, self.g, color.g)
        let b = lerp(t, self.b, color.b)
        let a = lerp(t, self.a, color.a)
        return RGBA(r: r, g: g, b: b, a: a)
    }
    
}


// MARK: - Utility

fileprivate let π = CGFloat.pi

fileprivate func lerp(_ t: Float, _ a: UInt8, _ b: UInt8) -> UInt8 {
    return UInt8(Float(a) + min(max(t, 0), 1) * (Float(b) - Float(a)))
}

fileprivate func lerp(_ value: Float, inRange: ClosedRange<Float>, outRange: ClosedRange<Float>) -> Float {
    return (value - inRange.lowerBound) * (outRange.upperBound - outRange.lowerBound) / (inRange.upperBound - inRange.lowerBound) + outRange.lowerBound
}


// MARK: - Extensions

extension Array {
    fileprivate subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

/*
 The MIT License (MIT)
 
 Copyright (c) 2015 Max Konovalov
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

import UIKit

// MARK: - Gradient View

open class MKGradientView: UIView {
    
    open var colors: [UIColor] = [.clear, .clear] {
        didSet {
            (layer as! MKGradientLayer).colors = colors.map { $0.cgColor }
        }
    }
    
    open var colors2: [UIColor] = [.clear, .clear] {
        didSet {
            (layer as! MKGradientLayer).colors2 = colors2.map { $0.cgColor }
        }
    }
    
    open var locations: [Float]? {
        didSet {
            (layer as! MKGradientLayer).locations = locations
        }
    }
    
    @IBInspectable open var startPoint: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            (layer as! MKGradientLayer).startPoint = startPoint
        }
    }
    
    @IBInspectable open var endPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            (layer as! MKGradientLayer).endPoint = endPoint
        }
    }
    
    open var startPoint2: CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            (layer as! MKGradientLayer).startPoint2 = startPoint2
        }
    }
    
    open var endPoint2: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            (layer as! MKGradientLayer).endPoint2 = endPoint2
        }
    }
    
    open var type: GradientType = .linear {
        didSet {
            (layer as! MKGradientLayer).type = type
        }
    }
    
    
    override open class var layerClass : AnyClass {
        return MKGradientLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        //layer.contentsScale = UIScreen.mainScreen().scale
        layer.needsDisplayOnBoundsChange = true
        layer.setNeedsDisplay()
    }
    
}


// MARK: Interface Builder Additions

@IBDesignable @available(*, unavailable, message : "This is reserved for Interface Builder")
extension MKGradientView {
    
    @IBInspectable public var gradientType: Int {
        set {
            if let type = GradientType(rawValue: newValue) {
                self.type = type
            }
        }
        get {
            return self.type.rawValue
        }
    }
    
    @IBInspectable public var startColor: UIColor {
        set {
            if colors.isEmpty {
                colors.append(newValue)
                colors.append(UIColor.clear)
            } else {
                colors[0] = newValue
            }
        }
        get {
            return (colors.count >= 1) ? colors[0] : UIColor.clear
        }
    }
    
    @IBInspectable public var endColor: UIColor {
        set {
            if colors.isEmpty {
                colors.append(UIColor.clear)
                colors.append(newValue)
            } else {
                colors[1] = newValue
            }
        }
        get {
            return (colors.count >= 2) ? colors[1] : UIColor.clear
        }
    }
    
    open override func prepareForInterfaceBuilder() {
        // To improve IB performance, reduce generated image size
        layer.contentsScale = 0.25
    }
    
}


// MARK: - Gradient Layer

open class MKGradientLayer: CALayer {
    
    /// The array of CGColorRef objects defining the color of each gradient stop.
    /// For `.bilinear` gradient type defines X-direction gradient stops.
    open var colors: [CGColor] = [UIColor.clear.cgColor, UIColor.clear.cgColor] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The array of Y-direction gradient stops for `.bilinear` gradient type.
    /// Ignored for other gradient types.
    open var colors2: [CGColor] = [UIColor.clear.cgColor, UIColor.clear.cgColor] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// An optional array of Floats defining the location of each gradient stop as a value in the range [0.0, 1.0]. The values must be monotonically increasing. If a nil array is given, the stops are assumed to spread uniformly across the [0.0, 1.0] range. The number of elements must be equal to `colors` array count.
    /// Defines X-direction color locations for `.bilinear` gradient type.
    open var locations: [Float]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// An optional array of Y-direction color locations for `.bilinear` gradient type. The number of elements must be equal to `colors2` array count.
    /// Ignored for other gradient types.
    open var locations2: [Float]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The start point of the gradient when drawn into the layer's coordinate space. The start point corresponds to the first gradient stop. The points are defined in a unit coordinate space that is then mapped to the layer's bounds rectangle when drawn. (I.e. [0.0, 0.0] is the bottom-left corner of the layer, [1.0, 1.0] is the top-right corner.).
    ///
    /// The default values for gradient types are:
    ///
    /// - `.linear`:  [0.5, 0.0] -> [0.5, 1.0]
    /// - `.radial`:  [0.5, 0.5] -> [1.0, 0.5]
    /// - `.conical`: [0.5, 0.5] -> [1.0, 0.5]
    /// - `.bilinear` (X-direction): [0.0, 0.5] -> [1.0, 0.5]
    open var startPoint: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The end point of the gradient when drawn into the layer's coordinate space. The end point corresponds to the last gradient stop. The points are defined in a unit coordinate space that is then mapped to the layer's bounds rectangle when drawn. (I.e. [0.0, 0.0] is the bottom-left corner of the layer, [1.0, 1.0] is the top-right corner.).
    open var endPoint: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The start point of the `.bilinear` gradient's Y-direction, defaults to [0.5, 0.0] -> [0.5, 1.0].
    /// Ignored for other gradient types.
    open var startPoint2: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The end point of the `.bilinear` gradient's Y-direction, defaults to [0.5, 0.0] -> [0.5, 1.0].
    /// Ignored for other gradient types.
    open var endPoint2: CGPoint? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// The kind of gradient that will be drawn.
    open var type: GradientType = .linear {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    // MARK: Content drawing
    
    override open func draw(in ctx: CGContext) {
        ctx.setFillColor(backgroundColor!)
        ctx.fill(bounds)
        
        let img = MKGradientGenerator.gradientImage(type: type, size: bounds.size, colors: colors, colors2: colors2, locations: locations, locations2: locations2, startPoint: startPoint, endPoint: endPoint, startPoint2: startPoint2, endPoint2: endPoint2, scale: contentsScale)
        ctx.draw(img, in: bounds)
    }
    
}
