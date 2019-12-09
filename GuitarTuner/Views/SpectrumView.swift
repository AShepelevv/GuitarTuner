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
        static let cornerRadiusSize = CGSize(width: 10.0, height: 10.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 20
        static let bottomBorder: CGFloat = 40
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
        static let labelHeight: CGFloat = 20.0
    }

    var startColor: UIColor = Color.orange
    var endColor: UIColor = Color.graphite

    var graphPoints: [Point2D] = [Point2D(0, 0)]
    var scale: Double = 1.0

    var width: CGFloat!
    var height: CGFloat!

    var xLabelsStackView = UIStackView()
    var yLabelsStackView = UIStackView()

    let xLabelsCount = 6

    var graphWidth: CGFloat {
        return self.width - Constants.margin * 2 - 4
    }

    var graphHeight: CGFloat {
        self.height - Constants.topBorder - Constants.bottomBorder
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = Constants.cornerRadiusSize.width
        clipsToBounds = true
        self.addSubview(xLabelsStackView)
        self.addSubview(yLabelsStackView)
        addXLabels()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {

        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()

        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!

        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)

        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])

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

    private func plot() -> UIBezierPath {
        let amplitudes = graphPoints.map({ $0.y })
        let maxValue = amplitudes.max() ?? 1.0

        let columnXPoint = { (column: Int) -> CGFloat in
            let spacing = self.graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + Constants.margin + 2
        }

        let columnYPoint = { (value: Double) -> CGFloat in
            let y = CGFloat(value) / CGFloat(maxValue) * self.graphHeight
            return self.graphHeight + Constants.topBorder - y // Flip the graph
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
        linePath.move(to: CGPoint(x: Constants.margin, y: Constants.topBorder))
        linePath.addLine(to: CGPoint(x: width - Constants.margin, y: Constants.topBorder))

        //center line
        linePath.move(to: CGPoint(x: Constants.margin, y: graphHeight/2 + Constants.topBorder))
        linePath.addLine(to: CGPoint(x: width - Constants.margin, y: graphHeight/2 + Constants.topBorder))

        //bottom line
        linePath.move(to: CGPoint(x: Constants.margin, y: height - Constants.bottomBorder))
        linePath.addLine(to: CGPoint(x: width - Constants.margin, y: height - Constants.bottomBorder))

        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
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
            label.font = UIFont(name: "Courier", size: 10.0)
            xLabelsStackView.addArrangedSubview(label)
        }
    }

    private func drawXLabels() {
        setXLabels()
        xLabelsStackView.frame = CGRect(x: Constants.margin,
                                        y: height - Constants.bottomBorder,
                                        width: width - 2 * Constants.margin,
                                        height: Constants.labelHeight)
        xLabelsStackView.distribution = .equalSpacing
    }
}
