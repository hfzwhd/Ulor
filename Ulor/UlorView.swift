//
//  UlorView.swift
//  Ulor
//
//  Created by Hafiz Wahid on 09/05/2017.
//  Copyright © 2017 hw. All rights reserved.
//

import Foundation
import UIKit

protocol UlorViewDelegate
{
    func ulorForUlorView(view:UlorView) -> Ulor?
    func pointOfFruitForUlorView(view:UlorView) -> Point?
}

class UlorView : UIView
{
    var delegate:UlorViewDelegate?
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.white
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        if let ulor:Ulor = delegate?.ulorForUlorView(view: self)
        {
            let worldSize = ulor.worldSize
            if worldSize.width <= 0 || worldSize.height <= 0
            {
                return
            }
            let w = Int(Float(self.bounds.size.width) / Float(worldSize.width))
            let h = Int(Float(self.bounds.size.height) / Float(worldSize.height))
            
            UIColor.black.set()
            let points = ulor.points
            for point in points
            {
                let rect = CGRect(x: point.x * w, y: point.y * h, width: w, height: h)
                UIBezierPath(rect: rect).fill()
            }
            
            if let fruit = delegate?.pointOfFruitForUlorView(view: self)
            {
                UIColor.red.set()
                let rect = CGRect(x: fruit.x * w, y: fruit.y * h, width: w, height: h)
                //UIBezierPath(ovalInRect: rect).fill()
                UIBezierPath(ovalIn: rect).fill()
            }
        }
    }
}
