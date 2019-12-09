//
//  SpectrumView.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 22/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit

class SpectrumView: UIView {
    
    // MARK: - Settings
    
    let cornerRadiusSize = CGSize(width: 10.0, height: 10.0)
    let margin: CGFloat = 20.0
    let topBorder: CGFloat = 20
    let bottomBorder: CGFloat = 40
    let colorAlpha: CGFloat = 0.3
    let labelHeight: CGFloat = 20.0
    
    let startColor: UIColor = Color.orange
    let endColor: UIColor = Color.graphite
    
    var graphPoints: [Point2D] = [Point2D(0, 0)]
    
    // MARK: - Properties
    
    private var width: CGFloat!
    private var height: CGFloat!
    
    private var xLabelsStackView = UIStackView()
    private var yLabelsStackView = UIStackView()
    
    private let xLabelsCount = 6
    
    private var graphWidth: CGFloat {
        return self.width - margin * 2 - 4
    }
    
    private var graphHeight: CGFloat {
        self.height - topBorder - bottomBorder
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = cornerRadiusSize.width
        clipsToBounds = true
        self.addSubview(xLabelsStackView)
        self.addSubview(yLabelsStackView)
        addXLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: cornerRadiusSize)
        path.addClip()
        
        drawGradient()
        
        width = rect.width
        height = rect.height
        
        Color.white.setFill()
        Color.white.setStroke()
        
        if !graphPoints.isEmpty {
            let graphPath = plot()
            graphPath.lineWidth = 2
            graphPath.stroke()
        }
        
        drawHorizontalGrid(width: self.width, height: self.height)
        drawXLabels()
    }
    
    // MARK: - Private utilities
    
    private func drawGradient() {
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
    
    private func plot() -> UIBezierPath {
        let amplitudes = graphPoints.map({ $0.y })
        let maxValue = amplitudes.max() ?? 1.0
        
        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = self.graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + self.margin + 2
        }
        
        let columnYPoint = { (value: Double) -> CGFloat in
            let y = CGFloat(value) / CGFloat(maxValue) * self.graphHeight
            return self.graphHeight + self.topBorder - y
        }
        
        let graphPath = UIBezierPath()
        
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(0)))
        for (i, point) in graphPoints.enumerated() {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(point.y))
            graphPath.addLine(to: nextPoint)
        }
        
        return graphPath
    }
    
    private func drawHorizontalGrid(width: CGFloat, height: CGFloat) {
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        
        let color = UIColor(white: 1.0, alpha: colorAlpha)
        color.setStroke()
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    private func setXLabels() {
        guard let labels = xLabelsStackView.arrangedSubviews as? [UILabel] else { return }
        for (i, label) in labels.enumerated() {
            label.text = String(format: "%.0f", graphPoints.last!.x * Double(i) / Double(xLabelsCount - 1))
        }
    }
    
    private func addXLabels() {
        for _ in 1...xLabelsCount {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = Color.white
            label.font = UIFont(name: Settings.fontName, size: 10.0)
            xLabelsStackView.addArrangedSubview(label)
        }
    }
    
    private func drawXLabels() {
        setXLabels()
        xLabelsStackView.frame = CGRect(x: margin,
                                        y: height - bottomBorder,
                                        width: width - 2 * margin,
                                        height: labelHeight)
        xLabelsStackView.distribution = .equalSpacing
    }
}
