//
//  LevelController.swift
//  Sudoku
//
//  Created by James Thang on 6/23/20.
//  Copyright © 2020 James Thang. All rights reserved.
//

import UIKit
import RealmSwift

class LevelController: UIViewController {
    
    let realm = try! Realm()
    var unSave: Results<SaveRealm>?
    
    private let sudokuData = SudokuData()
    private var sudokuGame: [SudokuModel]?
    private var number = 1
    private var second = 0
    private var minute = 0
    private var hour = 0
    
    private var continueGame: SudokuModel?
    
    var level: String? {
        didSet {
            switch level {
            case "Easy":
                sudokuGame = sudokuData.Easy
            case "Medium":
                sudokuGame = sudokuData.Medium
            case "Hard":
                sudokuGame = sudokuData.Hard
            case "Expert":
                sudokuGame = sudokuData.Expert
            default:
                sudokuGame = sudokuData.Easy
            }
            
            number = Int.random(in: 0 ..< sudokuGame!.count)
        }
    }
  
    @IBOutlet weak var continueBarBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        unSave = realm.objects(SaveRealm.self)
        if unSave!.isEmpty || unSave?.last?.unfinishGame == "" {
            continueBarBtn.isEnabled = false
        } else {
            continueBarBtn.isEnabled = true
            level = unSave!.last!.unfinishLevel
            continueGame = SudokuModel(question: unSave!.last!.unfinishGame, answer: unSave!.last!.unfinishGameAnswer)
            second = unSave!.last!.seconds
            minute = unSave!.last!.minutes
            hour = unSave!.last!.hours
        }
    }
    

    @IBAction func levelSelect(_ sender: UIButton) {
        level = sender.currentTitle!
//        print(sudokuGame?.count)
        performSegue(withIdentifier: "toSudoku", sender: self)
    }
    
    @IBAction func toIntro(_ sender: UIButton) {
        performSegue(withIdentifier: "toIntro", sender: self)
    }
    
    @IBAction func continueSelect(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "continue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSudoku" {
            let nextVC = segue.destination as! SudokuController
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.sudokuGame = sudokuGame![number]
            nextVC.level = level!
        } else if segue.identifier == "toIntro" {
            let nextVC = segue.destination as! IntroductionController
            nextVC.modalPresentationStyle = .fullScreen
        } else if segue.identifier == "continue" {
            let nextVC = segue.destination as! SudokuController
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.level = level!
            nextVC.sudokuGame = continueGame
            nextVC.numberOfSecond = second
            nextVC.numberOfMinute = minute
            nextVC.numberOfHour = hour
        }
    }
}
