//
//  SpectrumView.swift
//  GuitarTuner
//
//  Created by Aleksey Shepelev on 22/11/2019.
//  Copyright © 2019 ashepelev. All rights reserved.
//

import UIKit

class SpectrumView: UIView {
    
    private struct Constants {
      static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
      static let margin: CGFloat = 20.0
      static let topBorder: CGFloat = 60
      static let bottomBorder: CGFloat = 50
      static let colorAlpha: CGFloat = 0.3
      static let circleDiameter: CGFloat = 5.0
    }
    
    var startColor: UIColor = .red
    var endColor: UIColor = .green
    
    var graphPoints : [Float] = [0.0]
    
    override func draw(_ rect: CGRect) {
        
        // 2
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        
        // 3
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // 5
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        // 6
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        let path = UIBezierPath(roundedRect: rect,
                          byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        let width = rect.width
        let height = rect.height
        
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
          //Calculate the gap between points
          let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
          return CGFloat(column) * spacing + margin + 2
        }
        
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Float) -> CGFloat in
          let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
          return graphHeight + topBorder - y // Flip the graph
        }
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
            
        // set up the points line
        let graphPath = UIBezierPath()

        // go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
            
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
          let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
          graphPath.addLine(to: nextPoint)
        }

        graphPath.stroke()
    }
}
