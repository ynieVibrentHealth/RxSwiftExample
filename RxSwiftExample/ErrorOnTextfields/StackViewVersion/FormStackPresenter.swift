//
//  FormStackPresenter.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/5/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift

protocol FormStackPresenterInput {
    func process(_ response:FormStackModel.Functions.Response)
}

class FormStackPresenter: FormStackPresenterInput {
    public var output:FormStackViewInput?
    
    func process(_ response: FormStackModel.Functions.Response) {
        switch response {
        case .GetUser(let userDTO):
            generateUserViewModel(dto: userDTO)
        case .UpdateUserStatus(let status):
            let state = FormStackModel.Functions.State.UpdateUserStatus(status: status)
            output?.display(state)
        }
    }
    
    private func generateUserViewModel(dto:ACUserDTO) {
        let firstName = dto.firstName ?? ""
        let lastName = dto.lastName ?? ""
        let emailAddress = dto.emailAddress ?? ""
        
        let firstNameModel = ProfileFieldViewModel(value: firstName, placeHolder:"First Name")
        firstNameModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count < 1 {
                firstNameModel.errorMessage = "Please enter your first name."
                return false
            } else {
                firstNameModel.errorMessage = ""
                return true
            }
        }
        
        let lastNameModel = ProfileFieldViewModel(value: lastName, placeHolder:"Last Name")
        lastNameModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count < 1 {
                lastNameModel.errorMessage = "Please enter your last name."
                return false
            } else {
                lastNameModel.errorMessage = ""
                return true
            }
        }
        
        let emailAddressModel = ProfileFieldViewModel(value: emailAddress, placeHolder:"Email Address")
        emailAddressModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count < 1 {
                emailAddressModel.errorMessage = "Please enter your email address"
                return false
            } else if !HelperFunctions.isValid(inputString){
                emailAddressModel.errorMessage = "Please enter a valid email address"
                return false
            } else {
                emailAddressModel.errorMessage = ""
                return true
            }
        }
        
        let profileDict:[String:ProfileFieldViewModel] = [ProfileFieldKeys.FIRST_NAME:firstNameModel,
                                                          ProfileFieldKeys.LAST_NAME:lastNameModel,
                                                          ProfileFieldKeys.EMAIL_ADDRESS: emailAddressModel]
        
        let state = FormStackModel.Functions.State.DisplayUser(modelDictionary: profileDict)
        output?.display(state)
    }
}
