//
//  SaveRealm.swift
//  Sudoku
//
//  Created by James Thang on 7/18/20.
//  Copyright © 2020 James Thang. All rights reserved.
//

import Foundation
import RealmSwift

class SaveRealm: Object {
    @objc dynamic var unfinishGame: String = ""
    @objc dynamic var unfinishGameAnswer: String = ""
    @objc dynamic var unfinishLevel: String = "Easy"
    @objc dynamic var seconds: Int = 0
    @objc dynamic var minutes: Int = 0
    @objc dynamic var hours: Int = 0
 }
