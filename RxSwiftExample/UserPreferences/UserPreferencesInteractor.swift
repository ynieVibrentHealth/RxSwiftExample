//
//  UserPreferencesInteractor.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation

protocol UserPreferencesInteractorInput {
    func handle(_ request:UserPreferencesModel.Functions.Request)
}

class UserPreferencesInteractor:UserPreferencesInteractorInput {
    public var output:UserPreferencesPresenterInput?
    
    func handle(_ request: UserPreferencesModel.Functions.Request) {
        switch request {
        case .UserDetails:
            retrieveUserDetails()
        }
    }
    
    private func retrieveUserDetails() {
        
    }
}
