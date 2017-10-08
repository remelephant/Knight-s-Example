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
    
    // not refactored properties
    var someNum: Int = 0
    var someBool: Bool = false
    var number: Bool = true
    var stepIndex = 0
    var timer = Timer()
    
    // refactored properties
    let gameLogic = LogicFunctions()
    let board = Board()
    var boardSquareIndexesAndViews = [Int: UIView]()
    
    
    
    
    @IBAction func startAgainButtonPressed(_ sender: Any) {
        for item in boardSquareIndexesAndViews {
            if item.value.subviews.count != 0 {
                for view in item.value.subviews {
                    view.removeFromSuperview()
                }
            }
        }
        
        gameLogic.clear()
    }
    
    @IBAction func demoButtonPressed(_ sender: Any) {
        if gameLogic.example == .Demo {
            gameLogic.example = .Normal
        } else {
            gameLogic.example = .Demo
        }
        clear()
        number = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board.boardSize = 8
        boardSquareIndexesAndViews = board.createSquares()
        
        for row in 1...board.boardSize {
            for column in 1...board.boardSize {
                let index = board.boardScuareIndex(first: row, second: column)
                if let boardSquare = boardSquareIndexesAndViews[index] {
                    view.addSubview(boardSquare)
                    boardSquareIndexesAndViews[index]?.tag = index
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector (boardSquareTapped))
                    boardSquareIndexesAndViews[index]?.addGestureRecognizer(gestureRecognizer)
                }
            }
        }
    }
    
    func reloadBoard() {
        if someNum != 0 {
            switch gameLogic.example {
            case .Lose:
                lose()
            case .Win:
                win()
            case .Normal:
                
                if !number {
                    gameLogic.example = .Demo
                    fallthrough
                }
                
                let a = gameLogic.addKnight(dict: boardSquareIndexesAndViews, position: someNum)
                if a != nil {
//                    addSubviewToView(position: a!)
                }
                
                if gameLogic.example == .Lose {
                    lose()
                }
                
                
            case .Demo:
                
//                addSubviewToView(position: gameLogic.addKnight(dict: boardSquareIndexesAndViews, position: someNum)!)
                
                timer = Timer.scheduledTimer(timeInterval: 0.01,
                                             target: self,
                                             selector: #selector(self.myTimer),
                                             userInfo: nil,
                                             repeats: true)
                
            }
        }
    }
    
    func addButton(y: CGFloat, text: String) -> UIButton {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.frame = CGRect(origin: CGPoint(x: view.bounds.width/2 - 50, y: y), size: CGSize(width: 100, height: 20))
        button.setTitle(text, for: UIControlState.normal)
        return button
    }
    
    
    /// Functions
    func myTimer() {
        if someNum != 0 {
            someBool = true
            stepIndex += 1
            let bestPosition = gameLogic.findTheSmallestCount(position: someNum)
            
            let a = gameLogic.addKnight(dict: boardSquareIndexesAndViews, position: bestPosition)
            
            if a != nil {
//                addSubviewToView(position: a!)
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
            self.gameLogic.example = .Normal
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func lose() {
        let alertController = UIAlertController(title: "Game over", message:
            "Try again", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Start again", style: UIAlertActionStyle.default, handler: { (action) in
            self.clear()
            self.gameLogic.example = .Normal
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
//    func addSubviewToView(position: (view: UIView, stepNumber: Int)) {
//        
//        let view: UIView = position.0
//        let number: Int = position.1
//        
//        let toString = String(number)
//        view.addSubview(gameLogic.addKnightToPosition(view: view, number: toString))
//    }
    
    func clear() {
        boardSquareIndexesAndViews = [:]
        gameLogic.clear()
        someBool = false
        self.view.subviews.forEach({ $0.removeFromSuperview() })
        someNum = 0
        number = true
        stepIndex = 0
        timer.invalidate()
    }
    
    func boardSquareTapped(sender: UITapGestureRecognizer) {
        if let view = sender.view {
            if let knight = gameLogic.addKnight(dict: boardSquareIndexesAndViews, position: view.tag) {
                view.addSubview(gameLogic.addKnightToSquareView(view: knight.0, step: knight.1))
            }
        }
    }
}
