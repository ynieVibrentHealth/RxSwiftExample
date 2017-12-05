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
    var isValid:Variable<Bool>
    var value:Variable<String>
    let placeHolder:String
    var validationFunction:((_ inputString:String) -> Bool)?
    var errorMessage:String = ""
    
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
