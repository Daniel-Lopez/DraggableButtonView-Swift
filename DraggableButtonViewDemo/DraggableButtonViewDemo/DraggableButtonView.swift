//
//  DraggableButtonView.swift
//  DraggableButtonViewDemo
//
//  Created by Lopez, Daniel on 6/9/16.
//  Copyright © 2016 Lopez, Daniel. All rights reserved.
//

import UIKit

class DraggableButtonView: UIView, UIGestureRecognizerDelegate {
    
    private let DEFAULT_BG_COLOR: CGColor = UIColor.blackColor().CGColor
    private let DEFAULT_BG_OPACITY: Float = 0.4
    private let DEFAULT_STROKE_COLOR: CGColor = UIColor.clearColor().CGColor
    private let DEFAULT_STROKE_WIDTH: CGFloat = 2.0
    
    private var canDrag = false
    private var scaleFactor: CGFloat = 6.0
    private var initialPoint = CGPointZero
    private let circleLayer = CAShapeLayer()
    
    weak var delegate: DraggableButtonViewDelegate?
    weak var dataSource: DraggableButtonViewDataSource? {
        didSet {
            // Need to check that dataSource was not set to nil
            guard let ds = dataSource else { return }
            scaleFactor = ds.scaleFactor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panDetected))
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressDetected))
        
        panRecognizer.delegate = self
        longPressRecognizer.delegate = self
        
        self.addGestureRecognizer(panRecognizer)
        self.addGestureRecognizer(longPressRecognizer)
        
        backgroundColor = .clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc private func panDetected(gesture: UIPanGestureRecognizer) {
        guard canDrag else { return }
        
        let translation = gesture.translationInView(self.superview)
        self.center = CGPoint(x: initialPoint.x + translation.x, y: initialPoint.y + translation.y)
    }
    
    @objc private func longPressDetected(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .Began {
            canDrag = true
            circleLayer.transform = CATransform3DMakeScale(scaleFactor, scaleFactor, 1)
            
        } else if gesture.state == .Ended {
            canDrag = false
            circleLayer.transform = CATransform3DMakeScale(1.0, 1.0, 1)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
        if let sup = self.superview {
            sup.bringSubviewToFront(self)
            initialPoint = self.center
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let del = delegate else { return }
        
        if let touch = touches.first {
            let touchPoint = touch.locationInView(self.superview)
            del.draggableViewTapped(at: touchPoint)
        }
    }
    
    private func drawCircle(rect: CGRect) {
        
        let circlePath = UIBezierPath(roundedRect: rect, cornerRadius: rect.width / 2)
        circleLayer.path = circlePath.CGPath
        
        if let ds = dataSource {
            circleLayer.fillColor = ds.bgColor.CGColor
            circleLayer.opacity = ds.bgOpacity
            circleLayer.strokeColor = ds.strokeColor.CGColor
            circleLayer.lineWidth = CGFloat(ds.strokeWidth)
            
            if let image = ds.bgImage {
                let imageLayer = CALayer()
                imageLayer.contents = image.CGImage
                imageLayer.bounds = CGRect(x: 0, y: 0, width: rect.width / 2, height: rect.height / 2)
                imageLayer.position = CGPoint(x: rect.width / 2, y: rect.width / 2)
                circleLayer.addSublayer(imageLayer)
            }
        } else {
            circleLayer.fillColor = DEFAULT_BG_COLOR
            circleLayer.opacity = DEFAULT_BG_OPACITY
        }
        
        circleLayer.bounds = rect
        circleLayer.position = CGPoint(x: CGRectGetMidX(rect),y: CGRectGetMidY(rect))
        circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        layer.addSublayer(circleLayer)
    }
    
    override func drawRect(rect: CGRect) {
        drawCircle(rect)
    }
}


// MARK: - DraggableButtonViewDelegate

protocol DraggableButtonViewDelegate: class {
    // Passes the touch point in the button's super view
    func draggableViewTapped(at point: CGPoint)
}


// MARK: - DraggableButtonViewDataSource

protocol DraggableButtonViewDataSource: class {
    var bgColor:     UIColor { get }  // background color
    var bgOpacity:   Float   { get }  // background opacity
    var strokeColor: UIColor { get }  // stroke color
    var strokeWidth: CGFloat { get }  // stroke(line) width
    var scaleFactor: CGFloat { get }  // scale factor on long press
    var bgImage:    UIImage? { get }  // background image
}
