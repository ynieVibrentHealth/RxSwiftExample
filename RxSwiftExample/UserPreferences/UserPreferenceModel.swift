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
            case UserDetails(preferencesViewModel:UserPreferencesViewModel)
        }
    }
}
