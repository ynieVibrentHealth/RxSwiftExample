//
//  UserPreferenceModel.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation

struct UserPreferencesModel {
    struct Functions {
        enum Request {
            case UserDetails
        }
        enum Response {
            case UserDetails(userDTO: ACUserDTO)
        }
        enum State {
            case UserDetails(preferencesViewModel:[String: UserPreferencesViewModel])
        }
    }
    
    struct Keys {
        static let Email = "UserPreferencesDictKey_Email"
        static let Password = "UserPreferencesDictKey_Password"
        static let WithdrawPMI = "UserPreferencesDictKey_WithdrawPMI"
        static let PushNotifcations = "UserPreferencesDictKey_PushNotifications"
        static let EmailNotifications = "UserPreferencesDictKey_EmailNotifications"
        static let SMSN = "UserPreferencesDictKey_SMS"
        static let Language = "UserPreferencesDictKey_Language"
    }
}
