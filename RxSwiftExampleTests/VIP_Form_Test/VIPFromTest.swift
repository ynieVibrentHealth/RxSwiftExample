//
//  VIPFromTest.swift
//  RxSwiftExampleTests
//
//  Created by Yuchen Nie on 12/5/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import XCTest
import Quick
import Nimble
import RxSwift
@testable import RxSwiftExample

class VIPFromTest:QuickSpec {
    override func spec() {
        describe("Testing Presenter") {
            context("Creating View Model", closure: {
                //wired together mock interactor with real presenter, and presenter's output
                let mockInteractor = MockInteractor()
                let presenter = FormStackPresenter()
                let presenterOutput = ViewImpl()
                mockInteractor.output = presenter
                presenter.output = presenterOutput
                let userDTO = ACUserDTO()
                userDTO.firstName = "TestFirstName"
                userDTO.lastName = "TestLastName"
                userDTO.emailAddress = "aa2000@aa.com"
                
                mockInteractor.callOutput(with: userDTO)
                
                let outputViewModel = presenterOutput.modelDictionary
                
                it("Models are not empty", closure: {
                    expect(outputViewModel).toNot(beEmpty())
                })
                
                it("Has correct first name model", closure: {
                    if let firstNameModel = outputViewModel[ProfileFieldKeys.FIRST_NAME] {
                        expect(firstNameModel.value.value == "TestFirstName").to(beTrue())
                        expect(firstNameModel.placeHolder == "First Name").to(beTrue())
                        let isValid = firstNameModel.validationFunction?("testFirst")
                        expect(isValid).to(beTrue())
                        expect(firstNameModel.errorMessage == "").to(beTrue())
                    } else {
                        fail("first name field should not be empty")
                    }
                })
                
                it("Has correct last name model", closure: {
                    if let lastNameModel = outputViewModel[ProfileFieldKeys.LAST_NAME] {
                        expect(lastNameModel.value.value == "TestLastName").to(beTrue())
                        expect(lastNameModel.placeHolder == "Last Name").to(beTrue())
                        let isValid = lastNameModel.validationFunction?("")
                        expect(isValid).to(beFalse())
                        expect(lastNameModel.errorMessage == "").to(beFalse())
                        
                        let isValid2 = lastNameModel.validationFunction?("testLastName")
                        expect(isValid2).to(beTrue())
                        expect(lastNameModel.errorMessage == "").to(beTrue())
                    } else {
                        fail("last name field should not be empty")
                    }
                })
                
                it("Has correct email model", closure: {
                    if let emailAddressModel = outputViewModel[ProfileFieldKeys.EMAIL_ADDRESS] {
                        //Test if the values are set properly
                        expect(emailAddressModel.value.value == "aa2000@aa.com").to(beTrue())
                        
                        //Test empty email address
                        let isValid = emailAddressModel.validationFunction?("")
                        expect(isValid).to(beFalse())
                        
                        //Test email address format
                        let isValid2 = emailAddressModel.validationFunction?("invalidEmailAddress")
                        expect(isValid2).to(beFalse())
                        expect(emailAddressModel.errorMessage == "").to(beFalse())
                        
                        //Test valid email address
                        let isValid3 = emailAddressModel.validationFunction?("validEmail@aa.com")
                        expect(isValid3).to(beTrue())
                        expect(emailAddressModel.errorMessage == "").to(beTrue())
                    } else {
                        fail("email address field should not be empty")
                    }
                })
            })
            
            //Created a mock interactor and view
            class MockInteractor {
                var output:FormStackPresenterInput?
                public func callOutput(with userDTO:ACUserDTO) {
                    let response = FormStackModel.Functions.Response.GetUser(userDTO: userDTO)
                    output?.process(response)
                }
            }
            
            class ViewImpl:FormStackViewInput {
                public var modelDictionary:[String:ProfileFieldViewModel] = [:]
                func display(_ state: FormStackModel.Functions.State) {
                    switch state {
                    case .DisplayUser(let modelDictionary):
                        self.modelDictionary = modelDictionary
                    case .UpdateUserStatus(let status):
                        print(status)
                    }
                }
            }
        }
    }
}
