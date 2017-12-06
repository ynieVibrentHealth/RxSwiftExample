//
//  NameViewModel.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/4/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift


class ProfileFieldViewModel {
    var isValid:Variable<Bool>//Bool to see if user input is valid
    var value:Variable<String>//Value of user input
    let placeHolder:String
    var validationFunction:((_ inputString:String) -> Bool)?//injected function to determine if user input is valid
    var errorMessage:String = ""//generated error message if user input didn't meet criteria
    
    init(value:String, placeHolder:String, isValid:Bool = true) {
        self.isValid = Variable(isValid)
        self.value = Variable(value)
        self.placeHolder = placeHolder
    }
    
    public func setValidationFunction(validationFunction:@escaping ((_ inputString:String) -> Bool)) {
        self.validationFunction = validationFunction
    }
}

struct ProfileFieldKeys {
    static let FIRST_NAME = "PROFILE_FIELD_FIRST_NAME"
    static let LAST_NAME = "PROFILE_FIELD_LAST_NAME"
    static let EMAIL_ADDRESS = "PROFILE_FIELD_EMAIL_ADDRESS"
    
}
