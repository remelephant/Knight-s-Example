//
//  LogicFunctions.swift
//  Knight's tour
//
//  Created by Vahagn Gevorgyan on 3/31/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class LogicFunctions {
    
    private var numberColor: UIColor = UIColor(red: 193/255, green: 66/255, blue: 66/255, alpha: 1)
    private var workingArray: [Int] = []
    var specialNumber = 0
    
    enum PopUp {
        case Lose
        case Win
        case Normal
        case Demo
    }
    
    var stepCount: Int = 0
    
    var example = PopUp.Normal
    
    init() {
        for i in 11...88 {
            if i % 10 != 9 && i % 10 != 0 {
                self.workingArray.append(i)
            }
        }
    }
    
    var player: AVAudioPlayer?
    
    func playSound() {
        let url = Bundle.main.url(forResource: "wrong", withExtension: "mp3")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
        
    func findTheSmallestCount(position: Int) -> Int {
        if previousPositions.count == 0 {
            return position
        }
        
        let array = findSteps(position: position)
        var temp = [Int]()
        for i in array {
            temp.append(findSteps(position: i).count)
        }
        
        let index = temp.index(of: temp.min()!)
        
        return array[index!]
    }
    
    func addKnightToPosition(view: UIView, number: String) -> UIImageView {
        
        let imageName = "knight.5"
        let image = UIImage(named: imageName)
        
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 0, y: 0, width: (view.frame.width) , height: (view.frame.height))
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (view.frame.width/2) , height: (view.frame.height/2)))
        
        label.center = CGPoint(x: view.frame.width * 0.75, y: view.frame.height * 0.75)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = numberColor
        label.text = "\(number)"
        imageView.addSubview(label)
        return imageView
    }
    
    var previousPositions = [Int]()
    var rightView: UIView? = nil
    var check = [Int]()
    
    func addKnight(dict: [Int: UIView], position: Int) -> (UIView, Int)? {
        
        if findSteps(position: position).count == 0 && previousPositions.count == 63 {
                print("64")
                return(dict[position], position) as? (UIView, Int)
        }
        
        if previousPositions.count < 1 {
            previousPositions.append(position)
            return(dict[position]!, previousPositions.count)
        } else {
            check = findSteps(position: previousPositions[previousPositions.count - 1])
            if check.contains(position) {
                previousPositions.append(position)
                return(dict[position]!, previousPositions.count)
            } else {
                return nil
            }
        }
    }
    
    func clear() {
        previousPositions = []
        rightView = nil
        check = []
    }
    
    func addSubviewToView(position: (UIView, Int)) {
        let view: UIView = position.0
        let number: Int = position.1
        
        let toString = String(number)
        view.addSubview(addKnightToPosition(view: view, number: toString))
    }
    
    private func  findSteps(position: Int) -> [Int] {
        
        var stepList = [Int]()
        
        if workingArray.contains(position + 21) {
            stepList.append(position + 21)
        }
        if workingArray.contains(position + 19) {
            stepList.append(position + 19)
        }
        if workingArray.contains(position - 21) {
            stepList.append(position - 21)
        }
        if workingArray.contains(position - 19) {
            stepList.append(position - 19)
        }
        if workingArray.contains(position + 12) {
            stepList.append(position + 12)
        }
        if workingArray.contains(position - 8) {
            stepList.append(position - 8)
        }
        if workingArray.contains(position - 12) {
            stepList.append(position - 12)
        }
        if workingArray.contains(position + 8) {
            stepList.append(position + 8)
        }
        
        for number in previousPositions {
            if stepList.contains(number) {
                let index = stepList.index(of: number)
                stepList.remove(at: index!)
            }
        }
        
        return stepList
    }
}

