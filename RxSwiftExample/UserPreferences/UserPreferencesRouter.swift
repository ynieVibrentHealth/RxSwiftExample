//
//  UserPreferencesRouter.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/15/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit

enum UserPreferencesDestination {
    case ChangePassword
    case WithdrawFromPMI
    case PushNotificationsSettings
}

class UserPreferencesRouter {
    private var viewController:UIViewController?
    init(viewController:UIViewController?) {
        self.viewController = viewController
    }
    
    func navigateTo(destination:UserPreferencesDestination){
        switch destination {
        case .ChangePassword:
            print("Navigate to change password")
            break
        case .WithdrawFromPMI:
            print("Navigate to withdraw PMI")
            break
        case .PushNotificationsSettings:
            print("Navigate to settings app")
            break
        }
    }
}
