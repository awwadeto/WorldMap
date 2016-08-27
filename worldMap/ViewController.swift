//
//  ViewController.swift
//  worldMap
//
//  Created by Mohammad Awwad on 8/27/16.
//  Copyright © 2016 awwadeto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView : UIScrollView!
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var scale = 50000.0
    var mapView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = abs((appDelegate.boundaryBox[0] as! Double) - (appDelegate.boundaryBox[2] as! Double)) / scale
        let height = abs((appDelegate.boundaryBox[1] as! Double) - (appDelegate.boundaryBox[3] as! Double)) / scale

        scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height))
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSizeMake(CGFloat(width), CGFloat(height))
        scrollView.maximumZoomScale = 20.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        mapView = UIView(frame: CGRectMake(0, 0, CGFloat(width), CGFloat(height)))
        
        for geometry in appDelegate.geometries {
            switch geometry.type {
            case "Polygon":
                self.drawShapes("exterior" , coordinates: geometry.coordinates[0] as! NSArray)
                if geometry.coordinates.count != 1 {
                    self.drawShapes("interior", coordinates: geometry.coordinates[1] as! NSArray)
                }
            default:
                for coordinate in geometry.coordinates {
                    if let coordinate = coordinate as? NSArray {
                        self.drawShapes("exterior" , coordinates: coordinate[0] as! NSArray)
                        if coordinate.count != 1 {
                            self.drawShapes("interior", coordinates: coordinate[1] as! NSArray)
                        }
                    }
                }
            }
        }
        
        scrollView.addSubview(mapView)
        self.view.addSubview(scrollView)
    
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return mapView
    }
    
    func drawShapes (ringType : String , coordinates : NSArray) {
        
        let shape = CAShapeLayer()
        mapView.layer.addSublayer(shape)
        shape.opacity = 1.0
        shape.lineWidth = 0.2
        shape.lineJoin = kCALineJoinMiter
        
        if ringType == "exterior" {
            shape.strokeColor = UIColor.whiteColor().CGColor
            shape.fillColor = UIColor.grayColor().CGColor
        } else {
            shape.strokeColor = UIColor.grayColor().CGColor
            shape.fillColor = UIColor.whiteColor().CGColor
        }
        
        let path = UIBezierPath()
        
        for (index, element) in coordinates.enumerate()  {
            if let element = element as? NSArray {
                if index == 0 {
                    path.moveToPoint(CGPoint(x: mapView.center.x + CGFloat((element[0] as! Double / scale)), y: mapView.center.y + CGFloat((element[1] as! Double / scale) * -1)))
                } else {
                    path.addLineToPoint(CGPoint(x: mapView.center.x + CGFloat((element[0] as! Double / scale)), y: mapView.center.y + CGFloat((element[1] as! Double / scale) * -1)))
                }
            }
        }
        
        path.closePath()
        shape.path = path.CGPath
    }

}