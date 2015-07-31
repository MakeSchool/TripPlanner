//
//  TripDetailInfo.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/31/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit
//import QuartzCore

@IBDesignable
class TripDetailInfo: UIView {

  @IBInspectable var borderColor: UIColor = UIColor.darkGrayColor()
  @IBInspectable var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  var imageView: UIImageView = UIImageView()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    addLabel()
    addImageView(frame: frame)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addLabel()
    addImageView(frame: frame)
  }
  
  func addLabel() {
    let label = UILabel(frame: CGRectMake(10, 10, 200, 20))
    label.text = NSStringFromCGRect(frame)
    addSubview(label)
  }
  
  func addImageView(frame frame: CGRect) {
    let otherView = UIView(frame: CGRectMake(10, 10, 100, 100))
    otherView.backgroundColor = UIColor.redColor()
//    addSubview(otherView)
    
    imageView.contentMode = .ScaleAspectFill
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 50
    
    addSubview(imageView)
  }
  
  override func prepareForInterfaceBuilder() {
    
  }
  
  override func layoutSubviews() {
    imageView.frame = CGRectMake(0, 0, bounds.width-20, bounds.height-20)
    imageView.center = center
    imageView.layer.cornerRadius = imageView.bounds.size.width / 2
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    var frame = bounds
    CGContextSetLineWidth(context, 10)
    frame = CGRectInset(frame, 10, 10)
    borderColor.set()
//    UIRectFrame(frame)
    
    CGContextStrokeEllipseInRect(context, frame)
  }
  
}
