//
//  SupportingFunctions.swift
//  Knight's Example
//
//  Created by Vahagn Gevorgyan on 3/31/17.
//  Copyright © 2017 Vahagn Gevorgyan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Support {
    
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
        
    func findTheSmallestCount(array: [Int]) -> Int {
        var arrayOfArrays = [[Int]]()
        
        
        var arrayTemp = [Int]()
        
        for i in 0..<previousPositions.count {
            for j in 0..<array.count {
                if previousPositions[i] != array[j] {
                    arrayTemp.append(array[j])
                }
            }
        }

        for i in 0..<arrayTemp.count {
            arrayOfArrays.append(findSteps(position: arrayTemp[i]))
        }
        
        var temp = arrayOfArrays[0].count
        var index = 0
        for i in 0..<arrayOfArrays.count {
            if arrayOfArrays[i].count < temp && arrayOfArrays[i].count != 0 {
                temp = arrayOfArrays[i].count
                index = i
            }
        }

        return array[index]
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
    
    func printPossiableSteps(dict: [Int: UIView], position: Int, inDemoMode: Bool) {
        
        print("I am in the main")
        
        stepCount = 0
        
        player?.prepareToPlay()
    
        if inDemoMode {
            
            if rightView != nil && dict[position] != rightView {
                //            playSound()
            } else {
                previousPositions.append(position)
                let workArray = findSteps(position: position)
                
                if previousPositions.count < 2 {
                    dict[position]?.addSubview(addKnightToPosition(view: dict[position]!, number: "\(previousPositions.count)"))
                }
                
                
                
                if example == .Demo && position != 0 {
                    
                    print("I am in the demo, example is: ", example)
                    
                    let bestPosition = findTheSmallestCount(array: workArray)
                    rightView = dict[bestPosition]
                    dict[bestPosition]?.addSubview(addKnightToPosition(view: dict[bestPosition]!, number: "\(previousPositions.count + 1)"))
                    
                    _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
                        self.printPossiableSteps(dict: dict, position: bestPosition, inDemoMode: inDemoMode)
                    })
                    
                    stepCount += 1
                    print("stepCount is: ", stepCount)
                    
                }
                
            }
        } else {
            
            let workArray = findSteps(position: position)
            
            if workArray.isEmpty {
                example = .Lose
                print("Game over")
            }
            
            if check.isEmpty {
                previousPositions.append(position)
                check = workArray
                dict[position]?.addSubview(addKnightToPosition(view: dict[position]!, number: "\(previousPositions.count)"))
                
            } else {
                if check.contains(position) {
                    previousPositions.append(position)
                    dict[position]?.addSubview(addKnightToPosition(view: dict[position]!, number: "\(previousPositions.count)"))
                    check = workArray
                }

            }
        }
        
        print("PP.count: ", previousPositions.count)
        
    }
    
    func clear() {
        previousPositions = []
        rightView = nil
        check = []
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

