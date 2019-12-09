//
//  DialView.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 25/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import Foundation
import UIKit

class FrequencyDialView: UIView {
    
    // MARK: - Settings
    
    let maxFrequency = Int(Settings.maxFrequency)
    let fontSize: CGFloat = 18.0
    let labelHeight: CGFloat = 30.0
    let topMargin: CGFloat = 10.0
    let range: CGFloat = 4.5
    let minorStepDivider: CGFloat = 0.5
    let dialColor: UIColor = Color.graphite
    
    final lazy var frequency: CGFloat = {
        return range / 2.0
    }() 
    
    final lazy var majorStep = {
        return self.width / CGFloat(self.maxFrequency - 1)
    }()
    
    final lazy var minorStep = {
        return self.majorStep * minorStepDivider
    }()
    
    // MARK: - Properties
    
    private var dial: UIView!
    
    private var width: CGFloat!
    private var height: CGFloat!
    
    private var dialHeight: CGFloat!
    private var dialCenterY: CGFloat!
    private var labelCenterY: CGFloat!
    
    private var isDrawed = false

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.5
        layer.borderColor = dialColor.cgColor
        clipsToBounds = true
        self.isOpaque = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public API
    
    func moveTo(_ frequency: Double) {
        UIView.animate(withDuration: 1.0, animations: {
            self.dial.center = self.getCenter(of: frequency)
        })
        
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        if isDrawed {
            return
        } else {
            isDrawed = true
        }
        
        setupProrerties(for: rect)
        
        _ = (0...maxFrequency).map({ i in
            let dash = getDash(withWidth: 4, withHeight: dialHeight, withCenterX: CGFloat(i) * majorStep, withCenterY: dialCenterY)
            self.dial.addSubview(dash)
            
            let label = getFrequencyLabel()
            label.text = "\(i)"
            label.frame.size = CGSize(width: majorStep, height: labelHeight)
            label.center = CGPoint(x: CGFloat(i) * majorStep, y: labelCenterY)
            self.dial.addSubview(label)
        })
        
        _ = (1...maxFrequency).map({ i in
            let dash = getDash(withWidth: 3, withHeight: dialHeight / 1.5, withCenterX: (CGFloat(i) - 0.5) * majorStep, withCenterY: dialCenterY)
            self.dial.addSubview(dash)
        })
        
        drawPointer()
    }
    
    // MARK: - Private utilities
    
    private func getCenter(of frequency: Double) -> CGPoint {
        let internalX = (CGFloat(frequency) - CGFloat(self.maxFrequency) / 2.0) * majorStep + minorStep
        self.frequency = CGFloat(frequency)
        let newCenter = CGPoint(x: -internalX + self.frame.width / 2.0, y: height / 2.0)
        return newCenter
    }
    
    private func setupProrerties(for rect: CGRect) {
        height = rect.size.height
        width = rect.size.width / range * (CGFloat(maxFrequency) - 1.0)
        
        dial = UIView(frame: CGRect(x: rect.size.width / 2.0, y: 0, width: width, height: height))
        addSubview(dial)
        
        dialHeight = height - labelHeight - topMargin
        dialCenterY = dialHeight / 2.0 + topMargin
        labelCenterY = dialHeight + labelHeight / 2.0 + topMargin
    }
    
    private func getFrequencyLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: Settings.fontName, size: fontSize)
        label.textColor = dialColor
        label.textAlignment = .center
        return label
    }
    
    private func getDash(withWidth width: CGFloat, withHeight height: CGFloat, withCenterX x: CGFloat, withCenterY y: CGFloat) -> UIView {
        let dash = UIView()
        dash.frame.size = CGSize(width: width, height: height)
        dash.center = CGPoint(x: x, y: y)
        dash.backgroundColor = dialColor
        dash.layer.cornerRadius = 1
        return dash
    }
    
    private func drawPointer() {
        let path = UIBezierPath()
        let p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
        path.move(to: p0)
        
        let p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
        path.addLine(to: p1)
        
        let  dashes: [CGFloat] = [10, 5]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        path.lineWidth = 2
        path.lineCapStyle = .round
        dialColor.setStroke()
        path.stroke()
    }
}
