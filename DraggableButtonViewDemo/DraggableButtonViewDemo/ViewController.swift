//
//  ViewController.swift
//  DraggableButtonViewDemo
//
//  Created by Lopez, Daniel on 6/9/16.
//  Copyright © 2016 Lopez, Daniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let SIZE_OF_VIEW: CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let x = view.center.x
        let y = view.center.y
        
        let dragView = DraggableButtonView(frame: CGRect(x: x, y: y, width: SIZE_OF_VIEW, height: SIZE_OF_VIEW))
        
        dragView.delegate = self
        dragView.dataSource = self
        
        view.addSubview(dragView)
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

// MARK: - DraggableViewDataSource

extension ViewController: DraggableButtonViewDataSource {
    var bgColor: UIColor { return .blackColor() }
    var strokeColor: UIColor { return .lightGrayColor() }
    var bgOpacity: Float { return 0.5 }
    var strokeWidth: CGFloat { return 2.0 }
    var scaleFactor: CGFloat { return 4.0 }
    var bgImage: UIImage? { return UIImage(imageLiteral: "white-plus") }
}

// MARK: - DraggableViewDelegate

extension ViewController: DraggableButtonViewDelegate {
    
    func draggableViewTapped(at point: CGPoint) {
        let alert = UIAlertController(title: nil, message: "Tapped at \(point)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
