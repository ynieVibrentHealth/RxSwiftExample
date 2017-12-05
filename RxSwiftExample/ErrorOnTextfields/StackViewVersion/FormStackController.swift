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

class FormStackController:UIViewController {
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
    
    fileprivate lazy var barButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: nil)
        barButton.rx.tap
            .subscribe({ (tap) in
                print(tap)
            }).addDisposableTo(self.disposeBag)
        return barButton
    }()
    
    fileprivate lazy var disposeBag = DisposeBag()
    
    fileprivate lazy var nameValidationModel:NameViewModel = {
        let model = NameViewModel(firstNameValid: true, lastNameValid: true)
        Observable.combineLatest(model.firstNameValid.asObservable(), model.lastNameValid.asObservable(),
                                 resultSelector: { (firstName, lastName) -> Bool in
                                    if firstName, lastName {
                                        return true
                                    } else {
                                        return false
                                    }
        }).bind(to: self.barButton.rx.isEnabled).addDisposableTo(self.disposeBag)
        return model
    }()
    
    fileprivate lazy var firstNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.configure(with: "First Name", text: "Yuchen", valid: self.nameValidationModel.firstNameValid)
        inputField.validation = { (inputString) -> Bool in
            inputField.errorText = "First name is required"
            return inputString.count > 0
        }
        return inputField
    }()
    
    fileprivate lazy var lastNameView:FormTextFieldView = {
        let inputField = FormTextFieldView()
        inputField.configure(with: "Last Name", text: "Nie", valid: self.nameValidationModel.lastNameValid)
        inputField.validation = { (inputString) -> Bool in
            inputField.errorText = "Last name is required"
            return inputString.count > 0
        }
        return inputField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackContainer.addArrangedSubview(firstNameView)
        self.stackContainer.addArrangedSubview(lastNameView)
        self.navigationItem.rightBarButtonItem = barButton
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
