//
//  UserPreferencesViewModel.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift

protocol UserPreferencesViewModel {
    var placeHolder:String {get set}
}

class UserPreferencesSwitchViewModel:UserPreferencesViewModel {
    var value:Variable<Bool>
    var previousValue:Variable<Bool>
    var placeHolder:String
    
    init(value:Bool, placeHolder:String) {
        self.value = Variable(value)
        self.previousValue = Variable(value)
        self.placeHolder = placeHolder
    }
}

class UserPreferencesTextfieldViewModel:UserPreferencesViewModel {
    enum UserPreferencesTextFieldType {
        case Default
        case Hidden
    }
    
    var value:Variable<String>
    var previousValue:Variable<String>
    var placeHolder:String
    var textFieldType:UserPreferencesTextFieldType
    
    init(value:String, placeHolder:String, type:UserPreferencesTextFieldType = .Default) {
        self.value = Variable(value)
        self.previousValue = Variable(value)
        self.placeHolder = placeHolder
        self.textFieldType = type
    }
}

class UserPreferencesNotificationModel:UserPreferencesViewModel {
    enum NotifcationSetting {
        case SystemDisabled
        case Enabled
        case Disabled
        
        static func notifcationSetting(with isEnabled:Bool) -> NotifcationSetting {
            if isEnabled {
                return .Enabled
            } else {
                return .Disabled
            }
        }
    }
    
    var value: Variable<NotifcationSetting>
    var previousValue: Variable<NotifcationSetting>
    var placeHolder: String
    
    init(value:NotifcationSetting, placeHolder:String) {
        self.value = Variable(value)
        self.previousValue = Variable(value)
        self.placeHolder = placeHolder
    }
}
