//
//  FormStackPresenter.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/5/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import RxSwift
import PhoneNumberKit

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
        let middleInitial = dto.middleInitial ?? ""
        let lastName = dto.lastName ?? ""
        let emailAddress = dto.email ?? ""
        let phoneNumber = dto.phoneNumber ?? ""
        let birthDate = dto.dob ?? 0
        
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
        
        let middleInitialModel = ProfileFieldViewModel(value: middleInitial, placeHolder: "Middle Initial")
        middleInitialModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count > 1 {
                middleInitialModel.errorMessage = "Middle initial should be one character."
                return false
            } else {
                middleInitialModel.errorMessage = ""
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
        

        
        let dobModel = ProfileFieldViewModel(value: HelperFunctions.dateString(from: birthDate), placeHolder: "Date of Birth")
        dobModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count < 1 {
                lastNameModel.errorMessage = "Please select your birthdate."
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
        
        var profileDict:[String:ProfileFieldViewModel] = [ProfileFieldKeys.FIRST_NAME:firstNameModel,
                                                          ProfileFieldKeys.MIDDLE_INITIAL:middleInitialModel,
                                                          ProfileFieldKeys.LAST_NAME:lastNameModel,
                                                          ProfileFieldKeys.DATE_OF_BIRTH:dobModel,
                                                          ProfileFieldKeys.EMAIL_ADDRESS: emailAddressModel]
        
        if let addressDTO = dto.address {
            let addressDict = generateAddressViewModels(with: addressDTO)
            for (key, value) in addressDict {
                profileDict[key] = value
            }
        }
        
        if let phoneNumberFormatted = getPhoneNumber(from: phoneNumber) {
            let phoneNumberKit = PhoneNumberKit()
            let phoneNumberModel = ProfileFieldViewModel(value: phoneNumberKit.format(phoneNumberFormatted, toType: .national), placeHolder: "Phone Number")
            phoneNumberModel.setValidationFunction(validationFunction: { (inputString) -> Bool in
                if inputString.count < 1 {
                    phoneNumberModel.errorMessage = "Please enter valid phone number"
                    return false
                }
                do {
                    _ = try phoneNumberKit.parse(inputString, withRegion: "US", ignoreType: true)
                    phoneNumberModel.errorMessage = ""
                    return true
                } catch {
                    phoneNumberModel.errorMessage = "Please enter valid phone number"
                    return false
                }
            })
            profileDict[ProfileFieldKeys.PHONE_NUMBER] = phoneNumberModel
        }
        
        let state = FormStackModel.Functions.State.DisplayUser(modelDictionary: profileDict)
        output?.display(state)
    }
    
    private func getPhoneNumber(from phoneNumberString:String) -> PhoneNumber? {
        let phoneNumberKit = PhoneNumberKit()
        do {
            let phoneNumber = try phoneNumberKit.parse(phoneNumberString, withRegion: "US", ignoreType: true)
            return phoneNumber
        } catch {
            print("parsing error")
            return nil
        }
    }
    
    private func generateAddressViewModels(with addressDTO:ACUserAddressDTO) -> [String:ProfileFieldViewModel]{
        var addressViewModel:[String: ProfileFieldViewModel] = [:]
        let streetOne = addressDTO.streetOne ?? ""
        let streetTwo = addressDTO.streetTwo ?? ""
        let city = addressDTO.city ?? ""
        let state = addressDTO.state ?? ""
        let zip = addressDTO.zip ?? ""
        
        let streetOneModel = ProfileFieldViewModel(value: streetOne, placeHolder: "Street")
        streetOneModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count < 1 {
                streetOneModel.errorMessage = "Please enter your street address."
                return false
            } else {
                streetOneModel.errorMessage = ""
                return true
            }
        }
        addressViewModel[ProfileFieldKeys.STREET_ONE] = streetOneModel
        
        let streetTwoModel = ProfileFieldViewModel(value: streetTwo, placeHolder: "Unit #")
        addressViewModel[ProfileFieldKeys.UNIT] = streetTwoModel
        
        let cityModel = ProfileFieldViewModel(value: city, placeHolder: "City")
        cityModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count < 1 {
                cityModel.errorMessage = "Please enter your city."
                return false
            } else {
                cityModel.errorMessage = ""
                return true
            }
        }
        addressViewModel[ProfileFieldKeys.CITY] = cityModel
        
        let stateModel = ProfileFieldViewModel(value: state, placeHolder: "State")
        stateModel.setValidationFunction { (inputString) -> Bool in
            if inputString.count < 1 {
                stateModel.errorMessage = "Please enter your state."
                return false
            } else {
                stateModel.errorMessage = ""
                return true
            }
        }
        addressViewModel[ProfileFieldKeys.STATE] = stateModel
        
        let zipModel = ProfileFieldViewModel(value: zip, placeHolder: "Zipcode")
        zipModel.setValidationFunction { (inputString) -> Bool in
            if !inputString.isNumeric {
                zipModel.errorMessage = "Zipcode should be numbers."
                return false
            } else if inputString.count < 1 {
                zipModel.errorMessage = "Please enter your zipcode."
                return false
            } else {
                zipModel.errorMessage = ""
                return true
            }
        }
        addressViewModel[ProfileFieldKeys.ZIP] = zipModel
        
        return addressViewModel
    }
}
