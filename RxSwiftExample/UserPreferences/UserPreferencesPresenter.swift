//
//  UserPreferencesPresenter.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift

protocol UserPreferencesPresenterInput {
    func process(_ response:UserPreferencesModel.Functions.Response)
}

class UserPreferencesPresenter:UserPreferencesPresenterInput {
    public var output:UserPreferencesViewInput?
    
    func process(_ response: UserPreferencesModel.Functions.Response) {
        
    }
}
