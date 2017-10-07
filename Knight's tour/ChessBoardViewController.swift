//
//  ChessBoardViewController.swift
//  Knight's tour
//
//  Created by Vahagn Gevorgyan on 3/29/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

import UIKit
import AVFoundation

class ChessBoardViewController: UIViewController {
    
    let board = Board()
    var someNum: Int = 0
    let support = LogicFunctions()
    var arrayOf = [Int: UITapGestureRecognizer]()
    var myDict = [Int: UIView]()
    var someBool: Bool = false
    var number: Bool = true
    var stepIndex = 0
    var timer = Timer()

    
    func addButton(y: CGFloat, text: String) -> UIButton {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.frame = CGRect(origin: CGPoint(x: view.bounds.width/2 - 50, y: y), size: CGSize(width: 100, height: 20))
        button.setTitle(text, for: UIControlState.normal)
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        board.size = 8
        
        let button = addButton(y: 40, text: "Start again")
        let demo = addButton(y: 60, text: "Demo")
        
        if myDict.isEmpty {
            myDict = board.createSquares()
            self.view.addSubview(button)
            self.view.addSubview(demo)
            button.addTarget(self, action: #selector (start), for: UIControlEvents.touchUpInside)
            demo.addTarget(self, action: #selector (demoMode), for: UIControlEvents.touchUpInside)
        }
        
        for i in 1...board.size {
            for j in 1...board.size {
                let number = board.intForDict(first: i, second: j)
                view.addSubview(myDict[number]!)
                myDict[number]?.tag = number
                let gesture = UITapGestureRecognizer(target: self, action: #selector (recognize))
                arrayOf[number] = gesture
            }
        }
        
        for i in 1...board.size {
            for j in 1...board.size {
                let number = board.intForDict(first: i, second: j)
                myDict[number]?.addGestureRecognizer(arrayOf[number]!)
            }
        }
        
        if someNum != 0 {
            
            switch support.example {
                
            case .Lose:
                lose()
            case .Win:
                win()
            case .Normal:
                
                
                if !number {
                    support.example = .Demo
                    fallthrough
                }
                
                let a = support.addKnight(dict: myDict, position: someNum)
                if a != nil {
                    addSubviewToView(position: a!)
                }
                
                if support.example == .Lose {
                    lose()
                }
                
                
            case .Demo:
            
                addSubviewToView(position: support.addKnight(dict: myDict, position: someNum)!)
                
                timer = Timer.scheduledTimer(timeInterval: 0.01,
                                                       target: self,
                                                       selector: #selector(self.myTimer),
                                                       userInfo: nil,
                                                       repeats: true)
                
            }
        }
    }
    
    
    /// Functions
    func myTimer() {
        if someNum != 0 {
            someBool = true
            stepIndex += 1
            let bestPosition = support.findTheSmallestCount(position: someNum)
            
            let a = support.addKnight(dict: myDict, position: bestPosition)
            
            if a != nil {
                addSubviewToView(position: a!)
            }
            
            
            
            someNum = bestPosition
            
            if stepIndex == 63 {
                timer.invalidate()
                stepIndex = 0
                win()
                return
            }
            

            
        }
    }
    
    func win() {
        let alertController = UIAlertController(title: "You win", message:
            "Try one more time", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Start again", style: UIAlertActionStyle.default, handler: { (action) in
            self.clear()
            self.support.example = .Normal
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func lose() {
        let alertController = UIAlertController(title: "Game over", message:
            "Try again", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Start again", style: UIAlertActionStyle.default, handler: { (action) in
            self.clear()
            self.support.example = .Normal
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func addSubviewToView(position: (UIView, Int)) {
        
        let view: UIView = position.0
        let number: Int = position.1
        
        let toString = String(number)
        view.addSubview(support.addKnightToPosition(view: view, number: toString))
    }
    
    func start(sender: UIButton) {
        clear()
        number = true
        support.example = .Normal
        self.viewDidLoad()
    }
    
    func clear() {
        myDict = [:]
        arrayOf = [:]
        support.clear()
        someBool = false
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        someNum = 0
        number = true
        stepIndex = 0
        timer.invalidate()
        self.viewDidLoad()
    }
    
    func recognize(t: UITapGestureRecognizer) {
        
        if !someBool {
            if let i = arrayOf.values.index(of: t) {
                let key = arrayOf.keys[i]
                someNum = key
                self.viewDidLoad()
            } else {
                print("Error")
            }
        }
    }
    
//    func winOrLose() {
//        if support.previousPositions.count == 20 {
//            support.example = .Win
//            super.viewDidLoad()
//        }
//    }
//    
    
    func demoMode() {
        
        if support.example == .Demo {
            support.example = .Normal
        } else {
            support.example = .Demo
        }
        clear()
        number = false
        super.viewDidLoad()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
