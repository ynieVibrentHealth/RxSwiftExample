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
import PhoneNumberKit


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
                guard let viewModel = self?.profileDict else {return}
                let request = FormStackModel.Functions.Request.UpdateUser(profileDict: viewModel)
                self?.output?.handle(request)
            }).addDisposableTo(self.disposeBag)
        return barButton
    }()
    
    fileprivate lazy var disposeBag = DisposeBag()
    fileprivate lazy var profileDict:[String:ProfileFieldViewModel] = [:]
    
    /**
     Initializing each textField view. The only property that’s injected is the validation function; each textfield has a unique validation to determine if the user input matches what we expect. In addition, it also sets the error message for the case that the user input text is not valid. For instance, if the user enters an email address that isn’t valid, the error message displayed is:
     “Please enter a valid email address”
     
     Whereas if the user doesn’t enter an email address, the error message should be:
     “Email address is required”

     **/
    
    fileprivate lazy var nameHeader:FormStackHeaderView = {
        let header = FormStackHeaderView()
        header.configure(headerText: "about you")
        return header
    }()
    
    fileprivate lazy var firstNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        return inputField
    }()
    
    fileprivate lazy var lastNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        return inputField
    }()
    
    fileprivate lazy var birthDatePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.date
        return datePicker
    }()
    
    fileprivate lazy var dateOfBirthView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.textField.inputView = self.birthDatePicker
        inputField.textField.inputAccessoryView = self.getToolBar(cancelAction: { [weak self] in
            self?.dateOfBirthView.textField.resignFirstResponder()
            }, doneAction: { [weak self] in
                guard let date = self?.birthDatePicker.date else {return}
                self?.dateOfBirthView.textField.text = HelperFunctions.dateString(from: date)
                self?.dateOfBirthView.textField.resignFirstResponder()
        })
        return inputField
    }()
    
    fileprivate lazy var contactHeader:FormStackHeaderView = {
        let header = FormStackHeaderView()
        header.configure(headerText: "Contact Information")
        return header
    }()
    
    fileprivate lazy var emailView:FormTextFieldView = {
       let inputField = FormTextFieldView()
        inputField.textField.autocapitalizationType = .none
        inputField.textField.keyboardType = .emailAddress
        inputField.textField.spellCheckingType = .no
        return inputField
    }()
    
    fileprivate lazy var phoneNumberView:PhoneNumberFormTextFieldView = {
        let inputField = PhoneNumberFormTextFieldView()
        return inputField
    }()
    
    fileprivate lazy var addressHeader:FormStackHeaderView = {
        let header = FormStackHeaderView()
        header.configure(headerText: "Address")
        return header
    }()
    
    fileprivate lazy var streetView :FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.textField.autocapitalizationType = .none
        inputField.textField.spellCheckingType = .no
        return inputField
    }()
    
    fileprivate lazy var unitView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.textField.autocapitalizationType = .none
        inputField.textField.spellCheckingType = .no
        return inputField
    }()
    
    fileprivate lazy var cityView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.textField.autocapitalizationType = .none
        inputField.textField.spellCheckingType = .no
        return inputField
    }()
    
    fileprivate lazy var statePicker:UIPickerView = {
        let pickerView = UIPickerView()
        let states = UserProfileStateList.init().states
        let function = states.asObservable().bind(to: pickerView.rx.itemTitles)
        function({(index, stateModel) -> String in
            return stateModel.name
        }).addDisposableTo(self.disposeBag)
        return pickerView
    }()
    
    fileprivate lazy var stateView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.textField.autocapitalizationType = .none
        inputField.textField.spellCheckingType = .no
        inputField.textField.inputView = self.statePicker
        inputField.textField.inputAccessoryView = self.getToolBar(cancelAction: { [weak self] in
            self?.stateView.textField.resignFirstResponder()
            }, doneAction: { [weak self] in
                guard let stateIndex = self?.statePicker.selectedRow(inComponent: 0),
                let stateName = UserProfileStateList.init().states.value[stateIndex].name else {return}
                
                self?.stateView.textField.text = stateName
                self?.stateView.textField.resignFirstResponder()
        })
        return inputField
    }()
    
    fileprivate lazy var zipView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.textField.autocapitalizationType = .none
        inputField.textField.spellCheckingType = .no
        return inputField
    }()
    
    fileprivate lazy var hpoHeader:FormStackHeaderView = {
        let header = FormStackHeaderView()
        header.configure(headerText: "Health provider organization")
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackContainer.addArrangedSubview(nameHeader)
        self.stackContainer.addArrangedSubview(firstNameView)
        self.stackContainer.addArrangedSubview(lastNameView)
        self.stackContainer.addArrangedSubview(dateOfBirthView)
        
        self.stackContainer.addArrangedSubview(contactHeader)
        self.stackContainer.addArrangedSubview(emailView)
        self.stackContainer.addArrangedSubview(phoneNumberView)
        
        self.stackContainer.addArrangedSubview(addressHeader)
        self.stackContainer.addArrangedSubview(streetView)
        self.stackContainer.addArrangedSubview(unitView)
        self.stackContainer.addArrangedSubview(cityView)
        self.stackContainer.addArrangedSubview(stateView)
        self.stackContainer.addArrangedSubview(zipView)
        
        self.stackContainer.addArrangedSubview(hpoHeader)
        
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
    
    func getToolBar(cancelAction:@escaping (() -> Void), doneAction:@escaping (() -> Void))-> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:nil)
        doneButton.rx.tap.subscribe(onNext: { (_) in
            doneAction()
        }).addDisposableTo(self.disposeBag)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:nil)
        cancelButton.rx.tap.subscribe(onNext: { (_) in
            cancelAction()
        }).addDisposableTo(self.disposeBag)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
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
    
    private func setupUser(with modelDict:[String:ProfileFieldViewModel]) {
        /**
         Configuring each view with the appropriate properties including placeholder, validity model (a variable type containing a Bool), and the value model.
         **/
        
        var observables:[Observable<Bool>] = []
        if let firstNameModel = modelDict[ProfileFieldKeys.FIRST_NAME] {
            firstNameView.configure(profileViewModel: firstNameModel)
            observables.append(firstNameModel.isValid.asObservable())
        }
        
        if let lastNameModel = modelDict[ProfileFieldKeys.LAST_NAME] {
            lastNameView.configure(profileViewModel: lastNameModel)
            observables.append(lastNameModel.isValid.asObservable())
        }
        
        if let dateOfBirthModel = modelDict[ProfileFieldKeys.DATE_OF_BIRTH] {
            dateOfBirthView.configure(profileViewModel: dateOfBirthModel)
            birthDatePicker.date = HelperFunctions.date(from: dateOfBirthModel.value.value)
            observables.append(dateOfBirthModel.isValid.asObservable())
        }
        
        if let emailModel = modelDict[ProfileFieldKeys.EMAIL_ADDRESS] {
            emailView.configure(profileViewModel: emailModel)
            observables.append(emailModel.isValid.asObservable())
        }
        
        if let phoneModel = modelDict[ProfileFieldKeys.PHONE_NUMBER] {
            phoneNumberView.configure(profileViewModel: phoneModel)
            observables.append(phoneModel.isValid.asObservable())
        }
        
        if let streetModel = modelDict[ProfileFieldKeys.STREET_ONE] {
            streetView.configure(profileViewModel: streetModel)
            observables.append(streetModel.isValid.asObservable())
        }
        
        if let unitModel = modelDict[ProfileFieldKeys.UNIT] {
            unitView.configure(profileViewModel: unitModel)
            observables.append(unitModel.isValid.asObservable())
        }
        
        if let cityModel = modelDict[ProfileFieldKeys.CITY] {
            cityView.configure(profileViewModel: cityModel)
            observables.append(cityModel.isValid.asObservable())
        }
        
        if let stateModel = modelDict[ProfileFieldKeys.STATE] {
            stateView.configure(profileViewModel: stateModel)
            observables.append(stateModel.isValid.asObservable())
            if let selectedStateIndex = UserProfileStateList().states.value.index(where: { (model) -> Bool in
                return model.name == stateModel.value.value
            }) {
                statePicker.selectRow(selectedStateIndex, inComponent: 0, animated: false)
            }
        }
        
        if let zipModel = modelDict[ProfileFieldKeys.ZIP] {
            zipView.configure(profileViewModel: zipModel)
            observables.append(zipModel.isValid.asObservable())
        }

        self.profileDict = modelDict
        /**
         Combining the validation values for all fields
         In this function, the observable class is combining the checks of the name fields, and email field are valid and binding them to the state of the save bar button.
         **/
        Observable.combineLatest(observables) { (values) -> Bool in
            for value in values {
                if !value {
                    return false
                }
            }
            return true
        }.bind(to: self.barButton.rx.isEnabled).addDisposableTo(self.disposeBag)
    }
}
