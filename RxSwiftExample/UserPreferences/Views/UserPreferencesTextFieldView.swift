//
//  UserPreferncesTextFieldView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/12/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class UserPreferencesTextFieldView: UIView {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate lazy var notEditableTextfield:UITextField = {
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        self.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var placeHolderLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        self.addSubview(view)
        return view
    }()
    
    
    
    fileprivate lazy var actionLabel:UIButton = {
        let button = UIButton()
        button.setTitleColor(.blue, for: .normal)
        self.addSubview(button)
        return button
    }()
    
    fileprivate var viewModel:UserPreferencesTextfieldViewModel?
    public var changeAction:(() -> Void)?
    
    public func configure(with viewModel:UserPreferencesTextfieldViewModel) {
        self.viewModel = viewModel
        placeHolderLabel.text = viewModel.placeHolder
        switch viewModel.textFieldType {
        case .Hidden:
            notEditableTextfield.isSecureTextEntry = true
            notEditableTextfield.text = "XXXXXXXX"
            actionLabel.rx.tap.subscribe(onNext: { [weak self] (_) in
                self?.changeAction?()
            }).addDisposableTo(self.disposeBag)
            actionLabel.isUserInteractionEnabled = true
            actionLabel.setTitle("I have no idea", for: .normal)
        default:
            notEditableTextfield.isSecureTextEntry = false
            if let value = viewModel.value.value as? String {
                notEditableTextfield.text = value
            }
            actionLabel.isUserInteractionEnabled = false
            actionLabel.setTitle("", for: .normal)
        }
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        actionLabel.snp.updateConstraints { (make) in
            make.trailing.equalTo(self).inset(20)
            make.centerY.equalTo(self.notEditableTextfield)
            make.width.lessThanOrEqualTo(150)
        }
        
        notEditableTextfield.snp.updateConstraints { (make) in
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(actionLabel.snp.leading).offset(-10).priority(999)
            make.top.equalTo(self).inset(10).priority(999)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.top.equalTo(self.notEditableTextfield.snp.bottom).offset(5)
            make.leading.trailing.equalTo(self).inset(20).priority(999)
            make.height.equalTo(1)
        }
        
        placeHolderLabel.snp.updateConstraints { (make) in
            make.top.equalTo(self.dividerLine.snp.bottom).offset(5)
            make.leading.trailing.equalTo(dividerLine)
            make.bottom.equalTo(self).inset(10).priority(999)
        }
        super.updateConstraints()
    }
}
