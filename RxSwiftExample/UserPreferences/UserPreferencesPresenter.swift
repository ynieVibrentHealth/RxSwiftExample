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
        switch response {
        case .UserDetails(let userDTO):
            generateViewModel(with: userDTO)
        }
    }
    
    private func generateViewModel(with userDTO:ACUserDTO) {
        let email = userDTO.email ?? ""
        let password = userDTO.password ?? ""
        
        let emailViewModel = UserPreferencesViewModel(value: email, placeHolder: "Email Address")
        let passwordViewModel = UserPreferencesViewModel(value: password, placeHolder: "Password", type: .Hidden)
        
        let userPrefsDict:[String:UserPreferencesViewModel] = [UserPreferencesModel.Keys.Email:emailViewModel,
                                                               UserPreferencesModel.Keys.Password:passwordViewModel]
        let state = UserPreferencesModel.Functions.State.UserDetails(preferencesViewModel: userPrefsDict)
        output?.display(state)
    }
}
