//
//  ViewController.swift
//  DraggableButtonViewDemo
//
//  Created by Lopez, Daniel on 6/9/16.
//  Copyright © 2016 Lopez, Daniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let sizeOfView: CGFloat = 30.0
    let colorHexStrings = ["EFDC05", "30A9DE", "E53A40", "090707"]
    let colorNames = ["yellow", "blue", "red", "black"]
    var backViews = [UIView]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        addBackgroundViews()
        
        let x = view.center.x - sizeOfView/2
        let y = view.center.y - sizeOfView/2
        
        let dragView = DraggableButtonView(frame: CGRect(x: x, y: y, width: sizeOfView, height: sizeOfView))
        
        dragView.delegate = self
        dragView.dataSource = self
        
        view.addSubview(dragView)
    }
    
    func addBackgroundViews()
    {
        let size = CGSize(width: view.frame.width/2, height: view.frame.height/2)
        
        backViews.append(UIView(frame: CGRect(origin: CGPoint.zero, size: size)))
        backViews.append(UIView(frame: CGRect(origin: CGPoint(x: view.frame.width/2, y: 0), size: size)))
        backViews.append(UIView(frame: CGRect(origin: CGPoint(x: 0, y: view.frame.height/2), size: size)))
        backViews.append(UIView(frame: CGRect(origin: CGPoint(x: view.frame.width/2, y: view.frame.height/2), size: size)))
        
        for (i, backView) in backViews.enumerated()
        {
            backView.backgroundColor = colorFromHexString(colorHexStrings[i])
            view.addSubview(backView)
        }
    }
    
    func colorFromHexString (_ hex: String) -> UIColor
    {
        let cString: String = hex.trimmingCharacters(in: .whitespaces).uppercased()
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: CGFloat(1.0))
    }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}

// MARK: - DraggableViewDataSource

extension ViewController: DraggableButtonViewDataSource
{
    var bgColor:     UIColor  { return .black     }
    var strokeColor: UIColor  { return .lightGray }
    var bgOpacity:   Float    { return 0.5        }
    var strokeWidth: CGFloat  { return 2.0        }
    var scaleFactor: CGFloat  { return 5.0        }
    var bgImage:     UIImage? { return nil        }
//    var bgImage:     UIImage? { return UIImage(named: "white-plus") }
}

// MARK: - DraggableViewDelegate

extension ViewController: DraggableButtonViewDelegate
{
    func draggableViewTapped(at point: CGPoint)
    {
        var color = ""
        
        for (i, backView) in backViews.enumerated() where backView.frame.contains(point)
        {
            color = colorNames[i]
        }
        
        let alert = UIAlertController(title: nil, message: "Button tapped on the \(color) view", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
