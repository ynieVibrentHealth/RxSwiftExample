//
//  NameViewModel.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/4/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift

class NameViewModel {
    var firstNameValid:Variable<Bool>!
    var lastNameValid:Variable<Bool>!
    
    init(firstNameValid:Bool, lastNameValid:Bool) {
        self.firstNameValid = Variable(firstNameValid)
        self.lastNameValid = Variable(lastNameValid)
    }
}
