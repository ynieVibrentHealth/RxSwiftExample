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
    var firstNameValid:Variable<Bool>
    var lastNameValid:Variable<Bool>
    var emailAddressValid:Variable<Bool>
    
    var firstNameValue:Variable<String>
    var lastNameValue:Variable<String>
    var emailAddressValue:Variable<String>
    
    init(lastName:String, firstName:String, emailAddress:String) {
        self.firstNameValid = Variable(true)
        self.lastNameValid = Variable(true)
        self.firstNameValue = Variable(firstName)
        self.lastNameValue = Variable(lastName)
        self.emailAddressValid = Variable(true)
        self.emailAddressValue = Variable(emailAddress)
    }
}
