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
        let userDTO = ACUserDTO()
        userDTO.email = "aa2000@aa.com"
        userDTO.password = "password"
        
        let addressDTO = ACUserAddressDTO()
        addressDTO.phoneNumber = "2834560987"
        
        userDTO.address = addressDTO
        
        let userPreferences = ACUserPreferencesDTO()
        userPreferences.emailNotifications = false
        userPreferences.pushNotifications = false
        userPreferences.locale = "es"
        
        userDTO.userPreferences = userPreferences
        
        let response = UserPreferencesModel.Functions.Response.UserDetails(userDTO: userDTO)
        output?.process(response)
    }
}
