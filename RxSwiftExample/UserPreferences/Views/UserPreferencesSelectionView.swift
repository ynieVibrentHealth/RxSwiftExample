//
//  UserPreferencesSelectionView.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/13/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class UserPreferencesSelectionView: UIView {
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate let stringPickerAdapter = RxPickerViewStringAdapter<[ACLocaleMaster]>.init(components: [], numberOfComponents: { (datasource, pickerview, arrString) -> Int in
        return 1
    }, numberOfRowsInComponent: { (dataSource, pickerView, items, row) -> Int in
        return items.count
    }) { (dataSource, pickerView, items, row, _) -> String? in
        return items[row].localeName()
    }
    
    fileprivate lazy var selectionTextField:UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        self.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var titleLabel:UILabel = {
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
    
    fileprivate lazy var pickerView:UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    fileprivate lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:nil)
        doneButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.selectionTextField.resignFirstResponder()
            guard let _self = self,
                let selectedIndex = (self?.pickerView.selectedRow(inComponent: 0)),
            let selectedItem = _self.viewModel?.availableLocales.value[selectedIndex] else {return}
            _self.selectionTextField.text = selectedItem.localeName()
        }).addDisposableTo(self.disposeBag)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:nil)
        cancelButton.rx.tap.subscribe(onNext: { [weak self] (_) in
            self?.selectionTextField.resignFirstResponder()
        }).addDisposableTo(self.disposeBag)
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }()

    fileprivate var viewModel:UserPreferencesLanguageModel?
    
    public func configure(with viewModel:UserPreferencesLanguageModel) {
        self.viewModel = viewModel
        self.titleLabel.text = viewModel.placeHolder
        self.selectionTextField.text = viewModel.value.value.localeName()
        self.selectionTextField.inputView = self.pickerView
        self.selectionTextField.inputAccessoryView = self.toolBar
        viewModel.availableLocales.asObservable().bind(to: pickerView.rx.items(adapter: self.stringPickerAdapter)).addDisposableTo(self.disposeBag)
        
        if let selectedLanguageIndex = viewModel.availableLocales.value.index(where: { (model) -> Bool in
            return model == viewModel.value.value
        }) {
            pickerView.selectedRow(inComponent: selectedLanguageIndex)
        }
        
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        titleLabel.snp.updateConstraints { (make) in
            make.top.bottom.equalTo(self).inset(15).priority(999)
            make.leading.equalTo(self).inset(20)
            make.trailing.equalTo(self.selectionTextField.snp.leading).offset(-10)
        }
        
        selectionTextField.snp.updateConstraints { (make) in
            make.trailing.equalTo(self).inset(20).priority(999)
            make.centerY.equalTo(self.titleLabel)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.top.equalTo(self.selectionTextField.snp.bottom).offset(5)
            make.leading.trailing.equalTo(self).inset(20).priority(999)
            make.height.equalTo(1)
        }
        

        super.updateConstraints()
    }
}

