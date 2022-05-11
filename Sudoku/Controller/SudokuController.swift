//
//  ViewController.swift
//  Sudoku
//
//  Created by James Thang on 6/23/20.
//  Copyright © 2020 James Thang. All rights reserved.
//

import UIKit
import DropDown
import RealmSwift
import GoogleMobileAds

class SudokuController: UIViewController, GADFullScreenContentDelegate {

    let realm = try! Realm()
    var interstitial: GADInterstitialAd!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var modeDropdown: UIBarButtonItem!
    @IBOutlet weak var exitBtn: UIBarButtonItem!
    @IBOutlet weak var checkBtn: UIButton!
    
    var sudokuGame: SudokuModel?
    var level = "Easy"
    private var selectedIndexPath: IndexPath?
    var unSave: Results<SaveRealm>?
    let dropDown = DropDown()
    
    var timer = Timer()
    @IBOutlet weak var clockDisplay: UINavigationItem!
    
    var numberOfSecond: Int = 0
    var numberOfMinute: Int = 0
    var numberOfHour: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        unSave = realm.objects(SaveRealm.self)
        dropDown.dataSource = ["Classic", "SunShine", "Teal"]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SudokuCell", bundle: nil), forCellWithReuseIdentifier: "sudokuCell")
        collectionView.layer.borderWidth = 3.5
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(clock), userInfo: nil, repeats: true)
        checkBtn.isEnabled = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.backgroundColor = .white
        clockDisplay.standardAppearance = appearance
        
        setUpGoogleAds()
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dropDown.anchorView = modeDropdown
        dropDown.selectRow(at: 0)
    }
    

    @IBAction func exitSelect(_ sender: UIBarButtonItem) {
        var unsaveGame = ""
        for i in 0 ..< 81 {
            if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? SudokuCell {
                unsaveGame.append(cell.displayLabel.text!)
            }
        }

        if unsaveGame == sudokuGame!.answer {
            try! realm.write{
                unSave?.last?.unfinishGame = ""
                unSave?.last?.unfinishGameAnswer = ""
                unSave?.last?.unfinishLevel = ""
            }
        } else {
            if unSave!.isEmpty {
                try! realm.write{
                    let unsave = SaveRealm()
                    unsave.unfinishGame = unsaveGame
                    unsave.unfinishGameAnswer = sudokuGame!.answer
                    unsave.unfinishLevel = level
                    unsave.seconds = numberOfSecond
                    unsave.minutes = numberOfMinute
                    unsave.hours = numberOfHour
                    realm.add(unsave)
                }
            } else  {
                try! realm.write{
                    unSave?.last!.unfinishGame = unsaveGame
                    unSave?.last!.unfinishGameAnswer = sudokuGame!.answer
                    unSave?.last!.unfinishLevel = level
                    unSave?.last!.seconds = numberOfSecond
                    unSave?.last!.minutes = numberOfMinute
                    unSave?.last!.hours = numberOfHour
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func modeSelect(_ sender: UIBarButtonItem) {
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            switch item {
            case "Classic":
                self.view.backgroundColor = .systemBackground
                self.view.tintColor = .link
                self.modeDropdown.image = UIImage(systemName: "book.fill")
            case "SunShine":
                self.view.backgroundColor = .systemYellow
                self.view.tintColor = .black
                self.modeDropdown.image = UIImage(systemName: "sun.max.fill")
            case "Teal":
                self.view.backgroundColor = .systemTeal
                self.view.tintColor = .white
                self.modeDropdown.tintColor = .black
                self.exitBtn.tintColor = .black
                self.modeDropdown.image = UIImage(systemName: "cloud.drizzle")
            default:
                self.view.backgroundColor = .systemBackground
                self.view.tintColor = .link
            }
        }
    }
    
    @IBAction func answerSelect(_ sender: UIButton) {
        if let index = selectedIndexPath {
            if let cell = collectionView.cellForItem(at: index) as? SudokuCell {
                if sender.currentTitle! == "e" {
                    cell.displayLabel.text = " "
                } else if sender.currentTitle! == "h" {
                    
                    if interstitial != nil {
                        interstitial.present(fromRootViewController: self)
                    } else {
                        print("Ad wasn't ready")
                    }
                    
                    let arrayResult = sudokuGame!.answer.map( { String($0) })
                    cell.displayLabel.text = arrayResult[index.row]
                } else {
                    cell.displayLabel.text = sender.currentTitle!
                }
            }
        }
    }
    
    
    @IBAction func functionSelect(_ sender: UIButton) {
        if sender.currentTitle! == "d" {
            for i in 0 ..< 81 {
                if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? SudokuCell {
                    cell.backgroundColor = UIColor.white
                    cell.displayLabel.tintColor = .black
                }
            }
            
            checkBtn.isEnabled = true
            collectionView.reloadData()
            numberOfHour = 0
            numberOfMinute = 0
            numberOfSecond = 0
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(clock), userInfo: nil, repeats: true)

            
        } else if sender.currentTitle! == "c" {
            checkAnswer()
        }
    }
    
    func checkAnswer() {
        let arrayResult = sudokuGame!.answer.map( { String($0) })
        var mistake = 0

        for i in 0 ..< arrayResult.count {
            if let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? SudokuCell {
                if cell.displayLabel.text! != arrayResult[i] {
                    cell.displayLabel.text = arrayResult[i]
                    cell.backgroundColor = UIColor.red
                    mistake += 1
                }
            }
        }
        
        if mistake == 0 {
            let time = numberOfHour*3600 + numberOfMinute*60 + numberOfSecond
            let bestResult = UserDefaults.standard.integer(forKey: "best" + level)
            
            if bestResult == 0 || time < bestResult {
                UserDefaults.standard.set(time, forKey: "best" + level)
                UserDefaults.standard.set(clockDisplay.title, forKey: level)
            }
            performSegue(withIdentifier: "toSuccess", sender: self)
        }
        
        checkBtn.isEnabled = false
        timer.invalidate()
    }
    
    @objc func clock() {
        numberOfSecond += 1
        if numberOfSecond == 60 {
            numberOfMinute += 1
            numberOfSecond = 0
        }
        
        if numberOfMinute == 60 {
            numberOfHour += 1
            numberOfMinute = 0
        }
        
        var secondString = String(numberOfSecond)
        var minuteString = String(numberOfMinute)
        var hourString = String(numberOfHour)
        
        if numberOfSecond < 10 {
            secondString = "0\(numberOfSecond)"
        }
        
        if numberOfMinute < 10 {
            minuteString = "0\(numberOfMinute)"
        }
        
        if numberOfHour < 10 {
            hourString = "0\(numberOfHour)"
        }
        
        clockDisplay.title = hourString + ":" + minuteString + ":" + secondString
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSuccess" {
            let detailVC = segue.destination as! PopUpHistoryController
            detailVC.time = clockDisplay.title!
            detailVC.level = level
        }
    }
}

//MARK: - Collection display

extension SudokuController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 81
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sudokuCell", for: indexPath) as! SudokuCell
        
        if let arrayQuestion = sudokuGame?.question.map( { String($0) }) {
            cell.displayLabel.text = arrayQuestion[indexPath.row]
            if arrayQuestion[indexPath.row] == " " {
                cell.displayLabel.textColor = .blue
            } else {
                cell.displayLabel.textColor = .black
            }
        }
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        
        for cell in collectionView.visibleCells as [UICollectionViewCell] {
            cell.backgroundColor = UIColor.white
        }

        let arrayQuestions = sudokuGame!.question.map( { String($0) })
        if arrayQuestions[indexPath.row] == " " {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = UIColor.yellow
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let arrayQuestions = sudokuGame!.question.map( { String($0) })
        if arrayQuestions[indexPath.row] == " " {
            self.selectedIndexPath = indexPath
        } else {
            self.selectedIndexPath = nil
        }
    }
    
}

//MARK: - Google Add
extension SudokuController {
    private func setUpGoogleAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-9446229809644145/9718616961",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
}



