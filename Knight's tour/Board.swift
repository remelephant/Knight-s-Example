//
//  Board.swift
//  Knight's Example
//
//  Created by Vahagn Gevorgyan on 3/30/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

import UIKit

class Board: UIViewController {

    var size = 8
    
    private var rectSize: CGSize {
        get{
            if UIScreen.main.bounds.width <= UIScreen.main.bounds.height {
                return CGSize(width: UIScreen.main.bounds.width/CGFloat(size),
                              height: UIScreen.main.bounds.width/CGFloat(size))
            } else {
                return CGSize(width: UIScreen.main.bounds.height/CGFloat(size),
                              height: UIScreen.main.bounds.height/CGFloat(size))
            }
        }
    }
    
    private var rectFloat: CGFloat  {
        get{
            if UIScreen.main.bounds.width <= UIScreen.main.bounds.height {
                return CGFloat(UIScreen.main.bounds.width/CGFloat(size))
            } else {
                return CGFloat(UIScreen.main.bounds.width/CGFloat(size))
            }
        }
    }
    
    private var startPoint: CGFloat {
        get {
            if UIScreen.main.bounds.width <= UIScreen.main.bounds.height {
                let x = (Double(UIScreen.main.bounds.height) - Double(UIScreen.main.bounds.width)) / 2
                return CGFloat(x)
            } else {
                let x = (Double(UIScreen.main.bounds.width) - Double(UIScreen.main.bounds.height)) / 2
                return CGFloat(x)
            }
        }
    }
    
    func intForDict(first: Int, second: Int) -> Int {
        return first * 10 + second
    }
    
    var dictionaryOfViews = [Int:UIView]()
    
    var tap = UITapGestureRecognizer(target: mainViewController.self, action: #selector(tapOnTheView))
    

    var theDarker = UIColor(red: 198/255, green: 212/255, blue: 186/255, alpha: 1)
    var theLighter = UIColor(red: 241/255, green: 236/255, blue: 214/255, alpha: 1)
    
    
    func createSquares() -> [Int:UIView] {
        
        var theColorBool = true
        for i in 1...size {
            if size % 2 == 0 {
                theColorBool = !theColorBool
            }
            for j in 1...size {
                let point: CGPoint = CGPoint(x: (CGFloat(j - 1) * rectFloat),
                                             y: (CGFloat(i - 1) * rectFloat) + startPoint)
                let newView = UIView(frame: CGRect(origin: point, size: rectSize))
                if theColorBool {
                    newView.backgroundColor = theLighter
                } else {
                    newView.backgroundColor = theDarker
                }
                theColorBool = !theColorBool
                
                let number = intForDict(first: i, second: j)
                dictionaryOfViews[number] = newView
            }
        }
        return dictionaryOfViews
    }
    
    func tapOnTheView(t:UITapGestureRecognizer) {
        print("Hello")
    }
}


