//
//  DialView.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 25/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    open class var graphite: UIColor {
        get {
            return UIColor(named: "Graphite")!
        }
    }
    
    open class var orange: UIColor {
        get {
            return UIColor(named: "Orange")!
        }
    }
    
    open class var white: UIColor {
        get {
            return UIColor(named: "White")!
        }
    }
}

class FrequencyDialView : UIView {
    
    var dial : UIView!
    
    var width : CGFloat!
    var height : CGFloat!
    
    var isDrawed = false
    
    ////////////////////////////
    
    
    let maxFrequency = 1000
    let fontSize : CGFloat = 18.0
    let labelHeight : CGFloat = 30.0
    let topMargin : CGFloat = 10.0
    let range : CGFloat = 4.5
    
    
    var minX : CGFloat = 0.0
    lazy var frequency : CGFloat = {
        return range / 2.0
    }()
    
    lazy var majorStep = {
        return self.width / CGFloat(self.maxFrequency - 1)
    }()
    
    lazy var minorStep = {
        return self.majorStep / 2.0
    }()
    
    override init(frame : CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.graphite.cgColor
        clipsToBounds = true
        self.isOpaque = false
    }
    
    func moveTo(_ frequency : Double) {
        UIView.animate(withDuration: 1.0, animations: {
            self.dial.center = self.getCenter(of: frequency)
        })
        
    }
    
    private func getCenter(of frequency: Double) -> CGPoint {
        let internalX = (CGFloat(frequency) - CGFloat(self.maxFrequency) / 2.0) * majorStep + minorStep
        self.frequency = CGFloat(frequency)
        let newCenter = CGPoint(x: -internalX + self.frame.width / 2.0, y: height / 2.0)
        return newCenter
    }
    
    override func draw(_ rect: CGRect) {
        if isDrawed {
            return
        } else {
            isDrawed = true
        }
        
//        backgroundColor = UIColor.clear
        
//        let context = UIGraphicsGetCurrentContext()
        let rectPath = UIBezierPath(roundedRect: rect, cornerRadius: 10)
//        UIColor.red.setFill()
        rectPath.fill(with: .clear, alpha: 0.0)
        
        
        height = rect.size.height
        width = rect.size.width / range * (CGFloat(maxFrequency) - 1.0)
        
        dial = UIView(frame: CGRect(x: rect.size.width / 2.0, y: 0, width: width, height: height))
        self.addSubview(dial)
        
        let dialHeight = height - labelHeight - topMargin
        let dialCenterY = dialHeight / 2.0 + topMargin
        let labelCenterY = dialHeight + labelHeight / 2.0 + topMargin
        
        for i in 0...maxFrequency {
            let dash = UIView()
            dash.frame.size = CGSize(width: 4, height: dialHeight)
            dash.center = CGPoint(x: CGFloat(i) * majorStep, y: dialCenterY)
            dash.backgroundColor = .graphite
            dash.layer.cornerRadius = 2
            self.dial.addSubview(dash)
            
            let label = UILabel()
            label.text = "\(i)"
            label.font = UIFont(name: "Courier", size: fontSize)
            label.textColor = .graphite
            label.textAlignment = .center
            label.frame.size = CGSize(width: majorStep, height: labelHeight)
            label.center = CGPoint(x: CGFloat(i) * majorStep, y: labelCenterY)
            self.dial.addSubview(label)
        }
        
        for i in 1...maxFrequency {
            let dash = UIView()
            dash.frame.size = CGSize(width: 3, height: dialHeight / 1.5)
            dash.center = CGPoint(x: (CGFloat(i) - 0.5) * majorStep, y: dialCenterY)
            dash.backgroundColor = .graphite
            dash.layer.cornerRadius = 1
            self.dial.addSubview(dash)
        }
        
        let path = UIBezierPath()
        let p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
        path.move(to: p0)

        let p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
        path.addLine(to: p1)

        let  dashes: [CGFloat] = [10, 5]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.lineWidth = 2
        path.lineCapStyle = .round
        UIColor.graphite.setStroke()
        path.stroke()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
