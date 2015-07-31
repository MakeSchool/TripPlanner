//
//  TripDetailInfo.swift
//  TripPlanner
//
//  Created by Benjamin Encz on 7/31/15.
//  Copyright © 2015 Make School. All rights reserved.
//

import UIKit

@IBDesignable
class CircularImageView: UIView {

  @IBInspectable var borderColor: UIColor = UIColor.darkGrayColor()
  @IBInspectable var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  @IBInspectable var strokeWidth: CGFloat = 10
  
  var imageView: UIImageView = UIImageView()

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    addImageView(frame: frame)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addImageView(frame: frame)
  }
  
  func addImageView(frame frame: CGRect) {
    imageView.contentMode = .ScaleAspectFill
    imageView.layer.masksToBounds = true
    
    addSubview(imageView)
  }
  
  override func layoutSubviews() {
    imageView.frame = CGRectMake(0, 0, bounds.width-strokeWidth*2, bounds.height-strokeWidth*2)
    imageView.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
    imageView.layer.cornerRadius = imageView.bounds.size.width / 2
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    var frame = rect
    CGContextSetLineWidth(context, strokeWidth)
    frame = CGRectInset(frame, strokeWidth, strokeWidth)
    borderColor.set()
    
    CGContextStrokeEllipseInRect(context, frame)
  }
  
}
