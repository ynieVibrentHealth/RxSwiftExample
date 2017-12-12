//
//  UserPreferencesViewModel.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift

class UserPreferencesViewModel {
    enum UserPreferencesTextFieldType {
        case Default
        case Hidden
    }
    
    var value:Variable<Any>?
    var previousValue:Variable<Any>?
    var placeHolder:String
    var textFieldType:UserPreferencesTextFieldType
    
    init(value:Any, placeHolder:String, type:UserPreferencesTextFieldType = .Default) {
        self.value = Variable(value)
        self.previousValue = Variable(value)
        self.placeHolder = placeHolder
        self.textFieldType = type
    }
}
