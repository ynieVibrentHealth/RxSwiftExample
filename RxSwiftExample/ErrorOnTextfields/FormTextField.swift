//
//  FormTextField.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/4/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FormTextField:UITableViewCell {
    static let reuseID = "FormTextFieldCellReuseID"
    
    fileprivate lazy var disposeBag:DisposeBag = DisposeBag()
    
    fileprivate lazy var textField:UITextField = {
        let textField = UITextField()
        textField.rx.text
            .subscribe(onNext: { [weak self] (inputString) in
                guard let inputString = inputString else {return}
                if let isValid = self?.validation?(inputString),
                    !isValid {
                    self?.errorLabel.text = self?.errorText
                } else {
                    self?.errorLabel.text = ""
                }
                DispatchQueue.main.async {
                    self?.setNeedsUpdateConstraints()
                    self?.updateConstraintsIfNeeded()
                }
        }).addDisposableTo(self.disposeBag)
        self.contentView.addSubview(textField)
        return textField
    }()
    
    public var validation:((_ input:String) -> Bool)?
    
    fileprivate lazy var errorLabel:UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        return label
    }()
    
    public var errorText:String? = ""
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(view)
        return view
    }()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    init() {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: FormTextField.reuseID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with placeHolder:String, text:String) {
        textField.placeholder = placeHolder
        textField.text = text
    }
    
    override func updateConstraints() {
        textField.snp.updateConstraints { (make) in
            make.leading.top.trailing.equalTo(self.contentView).inset(10)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self.textField)
            make.height.equalTo(1.0)
            make.top.equalTo(textField.snp.bottom).offset(4)
        }
        
        errorLabel.snp.updateConstraints { (make) in
            make.top.equalTo(dividerLine.snp.bottom).offset(5)
            make.leading.trailing.equalTo(self.textField)
            make.bottom.equalTo(self.contentView).inset(5)
        }
        super.updateConstraints()
    }
}
