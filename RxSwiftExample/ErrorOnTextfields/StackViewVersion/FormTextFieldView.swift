//
//  FormTextFieldView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/4/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FormTextFieldView:UIView {
    
    fileprivate lazy var disposeBag:DisposeBag = DisposeBag()
    
    fileprivate lazy var textField:UITextField = {
        let textField = UITextField()
        textField.rx.text
            .subscribe(onNext: { [weak self] (inputString) in
                guard let inputString = inputString else {return}
                var newValue = ""
                if let isValid = self?.validation?(inputString),
                    !isValid {
                    newValue = (self?.errorText)!
                }
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
        self.addSubview(textField)
        return textField
    }()
    
    public var validation:((_ input:String) -> Bool)?
    
    fileprivate lazy var errorLabel:UILabel = {
        let label = UILabel()
        self.addSubview(label)
        return label
    }()
    
    public var errorText:String = ""
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        self.addSubview(view)
        return view
    }()
    public func configure(with placeHolder:String, text:String) {
        textField.placeholder = placeHolder
        textField.text = text
    }
    
    override func updateConstraints() {
        textField.snp.updateConstraints { (make) in
            make.leading.top.trailing.equalTo(self).inset(10).priority(999)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self.textField)
            make.height.equalTo(1.0)
            make.top.equalTo(textField.snp.bottom).offset(4)
        }
        
        errorLabel.snp.updateConstraints { (make) in
            make.trailing.leading.equalTo(self.textField)
            make.top.equalTo(dividerLine.snp.bottom).offset(5)
            make.bottom.equalTo(self).inset(5)
        }
        super.updateConstraints()
    }
}
