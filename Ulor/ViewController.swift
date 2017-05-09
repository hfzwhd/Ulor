//
//  ViewController.swift
//  Ulor
//
//  Created by Hafiz Wahid on 08/05/2017.
//  Copyright © 2017 hw. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UlorViewDelegate
{
    @IBOutlet weak var startButton: UIButton!
    
    var ulorView:UlorView?
    var timer:Timer?
    var ulor:Ulor?
    var fruit:Point?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.ulorView = UlorView(frame: self.view.bounds)
        self.ulorView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(self.ulorView!, at: 0)
        
        if let view = self.ulorView
        {
            view.delegate = self
        }
        for direction in [UISwipeGestureRecognizerDirection.right,
                          UISwipeGestureRecognizerDirection.left,
                          UISwipeGestureRecognizerDirection.up,
                          UISwipeGestureRecognizerDirection.down]
        {
            let gr = UISwipeGestureRecognizer(target: self, action: #selector(swipe(gr:)))
            gr.direction = direction
            self.view.addGestureRecognizer(gr)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func swipe(gr:UISwipeGestureRecognizer)
    {
        let direction = gr.direction
        switch direction
        {
        case UISwipeGestureRecognizerDirection.right:
            if (self.ulor?.changeDirection(newDirection: Direction.right) != nil)
            {
                self.ulor?.lockDirection()
            }
        case UISwipeGestureRecognizerDirection.left:
            if (self.ulor?.changeDirection(newDirection: Direction.left) != nil)
            {
                self.ulor?.lockDirection()
            }
        case UISwipeGestureRecognizerDirection.up:
            if (self.ulor?.changeDirection(newDirection: Direction.up) != nil)
            {
                self.ulor?.lockDirection()
            }
        case UISwipeGestureRecognizerDirection.down:
            if (self.ulor?.changeDirection(newDirection: Direction.down) != nil)
            {
                self.ulor?.lockDirection()
            }
        default:
            assert(false, "This could not happen")
        }
    }
    
    func makeNewFruit()
    {
        srandomdev()
        let worldSize = self.ulor!.worldSize
        var x = 0
        var y: Int = 0
        while (true)
        {
            
            x = Int(arc4random()) % worldSize.width
            y = Int(arc4random()) % worldSize.height
            var isBody = false
            for p in self.ulor!.points
            {
                if p.x == x && p.y == y
                {
                    isBody = true
                    break
                }
            }
            if !isBody
            {
                break
            }
        }
        self.fruit = Point(x: x, y: y)
    }
    
    func startGame()
    {
        if (self.timer != nil)
        {
            return
        }
        
        self.startButton!.isHidden = true
        let worldSize = WorldSize(width: 24, height: 15)
        self.ulor = Ulor(inSize: worldSize, length: 2)
        self.makeNewFruit()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerMethod(timer:)), userInfo: nil, repeats: true)
        self.ulorView!.setNeedsDisplay()
    }
    
    func endGame() {
        self.startButton!.isHidden = false
        self.timer!.invalidate()
        self.timer = nil
    }
    
    func timerMethod(timer:Timer) {
        self.ulor?.move()
        let headHitBody = self.ulor?.isHeadHitBody()
        if headHitBody == true {
            self.endGame()
            return
        }
        
        let head = self.ulor?.points[0]
        if head?.x == self.fruit?.x && head?.y == self.fruit?.y
        {
            self.ulor!.increaseLength(inLength: 2)
            self.makeNewFruit()
        }
        
        self.ulor?.unlockDirection()
        self.ulorView!.setNeedsDisplay()
    }
    
    @IBAction func startButtonTapped(_ sender: Any)
    {
        self.startGame()
    }
    
    func ulorForUlorView(view:UlorView) -> Ulor?
    {
        return self.ulor
    }
    
    func pointOfFruitForUlorView(view:UlorView) -> Point?
    {
        return self.fruit
    }
    
    
    


}

