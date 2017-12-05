//
//  FormStackModel.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/5/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation

struct FormStackModel {
    struct Functions {
        enum Request{
            case GetUser
            case UpdateUser(viewModel:NameViewModel)
        }
        
        enum Response {
            case GetUser(userDTO:ACUserDTO)
            case UpdateUserStatus(status:Bool)
        }
        
        enum State {
            case DisplayUser(viewModel:NameViewModel)
            case UpdateUserStatus(status:Bool)
        }
    }
}
