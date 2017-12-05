//
//  FormStackController.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/4/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa

protocol FormStackViewInput {
    func display(_ state:FormStackModel.Functions.State)
}

class FormStackController:UIViewController {
    public var output:FormStackInteractorInput?
    
    fileprivate lazy var scrollContainer:UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.backgroundColor = .white
        scrollView.alwaysBounceVertical = false
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    fileprivate lazy var stackContainer:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        self.scrollContainer.addSubview(stackView)
        return stackView
    }()
    
    
    /**
     Instead of using the standard target action that UIKit uses, this leverages the RxCocoa framework to inject the action that responds to user tap.
     
     There’s nothing wrong with the methodology of defining a selector, however, having an action that runs in a different area of code can cause confusing.
     
     By doing this, we are able to set the action directly in the block initialization of the button.

     **/
    fileprivate lazy var barButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: nil)
        barButton.rx.tap
            .subscribe({ [weak self] (tap) in
                guard let viewModel = self?.nameViewModel else {return}
                let request = FormStackModel.Functions.Request.UpdateUser(viewModel: viewModel)
                self?.output?.handle(request)
            }).addDisposableTo(self.disposeBag)
        return barButton
    }()
    
    fileprivate lazy var disposeBag = DisposeBag()
    
    fileprivate var nameViewModel:NameViewModel?
    
    /**
     Initializing each textField view. The only property that’s injected is the validation function; each textfield has a unique validation to determine if the user input matches what we expect. In addition, it also sets the error message for the case that the user input text is not valid. For instance, if the user enters an email address that isn’t valid, the error message displayed is:
     “Please enter a valid email address”
     
     Whereas if the user doesn’t enter an email address, the error message should be:
     “Email address is required”

     **/
    
    fileprivate lazy var firstNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.validation = { (inputString) -> Bool in
            inputField.errorText = "First name is required"
            return inputString.count > 0
        }
        return inputField
    }()
    
    fileprivate lazy var lastNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.validation = { (inputString) -> Bool in
            inputField.errorText = "Last name is required"
            return inputString.count > 0
        }
        return inputField
    }()
    
    fileprivate lazy var emailView:FormTextFieldView = {
       let inputField = FormTextFieldView()
        inputField.validation = { (inputString) -> Bool in
            if inputString.count < 1 {
                inputField.errorText = "Email address is required"
                return false
            } else if !HelperFunctions.isValid(inputString) {
                inputField.errorText = "Please enter a valid email address"
                return false
            }
            return true
        }
        inputField.textField.autocapitalizationType = .none
        inputField.textField.spellCheckingType = .no
        return inputField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackContainer.addArrangedSubview(firstNameView)
        self.stackContainer.addArrangedSubview(lastNameView)
        self.stackContainer.addArrangedSubview(emailView)
        self.navigationItem.rightBarButtonItem = barButton
        
        //sending request to interactor
        let request = FormStackModel.Functions.Request.GetUser
        output?.handle(request)
    }
    
    override func viewWillLayoutSubviews() {
        scrollContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        stackContainer.snp.updateConstraints { (make) in
            make.edges.equalTo(scrollContainer)
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        super.viewWillLayoutSubviews()
    }
}

extension FormStackController:FormStackViewInput {
    func display(_ state: FormStackModel.Functions.State) {
        switch state {
        case .DisplayUser(let viewModel):
            setupUser(with: viewModel)
        case .UpdateUserStatus(let status):
            handleUpdateUser(status: status)
        }
    }
    
    private func handleUpdateUser(status:Bool) {
        if status{
            print("Update user successful")
        } else {
            print("Update user failed")
        }
    }
    
    private func setupUser(with viewModel:NameViewModel) {
        /**
         Configuring each view with the appropriate properties including placeholder, validity model (a variable type containing a Bool), and the value model.
         **/
        firstNameView.configure(placeHolder: "First Name", valid: viewModel.firstNameValid, value: viewModel.firstNameValue)
        lastNameView.configure(placeHolder: "Last Name", valid: viewModel.lastNameValid, value: viewModel.lastNameValue)
        emailView.configure(placeHolder: "Email Address", valid: viewModel.emailAddressValid, value: viewModel.emailAddressValue)
        self.nameViewModel = viewModel
        /**
        Combining the validation values for all fields
         In this function, the observable class is combining the checks of the name fields, and email field are valid and binding them to the state of the save bar button.
         **/
        Observable.combineLatest(viewModel.firstNameValid.asObservable(),
                                 viewModel.lastNameValid.asObservable(),
                                 viewModel.emailAddressValid.asObservable(),
                                 resultSelector: { (firstName, lastName, emailAddress) -> Bool in
                                    if firstName, lastName, emailAddress {
                                        return true
                                    } else {
                                        return false
                                    }
        }).bind(to: self.barButton.rx.isEnabled).addDisposableTo(self.disposeBag)
    }
}
