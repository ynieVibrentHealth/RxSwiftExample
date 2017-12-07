//
//  PhoneNumberTextFieldView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/7/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PhoneNumberKit

class PhoneNumberFormTextFieldView:UIView {
    
    fileprivate lazy var disposeBag:DisposeBag = DisposeBag()
    fileprivate var viewModel:ProfileFieldViewModel?
    
    fileprivate lazy var phoneNumberTextField:PhoneNumberTextField = {
        let phoneNumberTextField = PhoneNumberTextField()
        phoneNumberTextField.autocorrectionType = .no
        self.addSubview(phoneNumberTextField)
        return phoneNumberTextField
    }()
    
    fileprivate lazy var errorLabel:UILabel = {
        let label = UILabel()
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        self.addSubview(view)
        return view
    }()
    
    /**
     In the configure function, we subscribe the textField using RxCocoa to validate the user input.
     **/
    public func configure(profileViewModel:ProfileFieldViewModel) {
        phoneNumberTextField.placeholder = profileViewModel.placeHolder
        phoneNumberTextField.text = profileViewModel.value.value
        phoneNumberTextField.rx.text
            .subscribe(onNext: { [weak self] (inputString) in
                guard let inputString = inputString else {return}
                var newValue = ""
                /**
                 Run the injected validation function. If the validation fails, the error label shows the text that was also injected.
                 **/
                if let isValid = self?.viewModel?.validationFunction?(inputString),
                    !isValid {
                    newValue = (self?.viewModel?.errorMessage)!
                    self?.viewModel?.isValid.value = false
                } else {
                    self?.viewModel?.isValid.value = true
                }
                
                //Aninmate the error label
                UIView.animate(withDuration: 0.25) {
                    self?.errorLabel.text = newValue
                    self?.errorLabel.setNeedsLayout()
                    self?.setNeedsLayout()
                    self?.superview?.setNeedsLayout()
                    self?.errorLabel.layoutSubviews()
                    self?.layoutSubviews()
                    self?.superview?.layoutSubviews()
                }
            }).addDisposableTo(self.disposeBag)
        
        /**
         On editing did end, we subscribe to the editing did end delegate method for a textField. Similar to using the tap function of a button, by using RxCocoa we are able to directly set a function instead of placing it somewhere else the way we would have to using a selector.
         **/
        phoneNumberTextField.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: { _ in
            guard let textFieldText = self.phoneNumberTextField.text else {return}
            self.viewModel?.value.value = textFieldText
        }).addDisposableTo(disposeBag)
        
        self.viewModel = profileViewModel
    }
    
    override func updateConstraints() {
        phoneNumberTextField.snp.updateConstraints { (make) in
            make.leading.top.trailing.equalTo(self).inset(10).priority(999)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self.phoneNumberTextField)
            make.height.equalTo(1.0)
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(4)
        }
        
        errorLabel.snp.updateConstraints { (make) in
            make.trailing.leading.equalTo(self.phoneNumberTextField)
            make.top.equalTo(dividerLine.snp.bottom).offset(5)
            make.bottom.equalTo(self).inset(5)
        }
        super.updateConstraints()
    }
}
