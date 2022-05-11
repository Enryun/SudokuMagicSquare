//
//  PopUpHistoryController.swift
//  Sudoku
//
//  Created by James Thang on 8/28/20.
//  Copyright © 2020 James Thang. All rights reserved.
//

import UIKit

class PopUpHistoryController: UIViewController {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bestTimeLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    
    var time = ""
    var level = "Easy"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        levelLabel.text = level
        timeLabel.text = time
        bestTimeLabel.text = UserDefaults.standard.string(forKey: level)
        let yourColor : UIColor = UIColor( red: 0.7, green: 0.3, blue:0.1, alpha: 1.0 )
        resultView.layer.borderWidth = 1
        resultView.layer.borderColor = yourColor.cgColor
    }
    

    @IBAction func newGameBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
//        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
