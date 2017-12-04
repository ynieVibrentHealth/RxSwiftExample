//
//  FormTableController.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/4/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FormTableController:UIViewController {
    enum InputField {
        case FirstName
        case LastName
    }
    
    fileprivate var fields:[InputField] = [.FirstName, .LastName]
    
    fileprivate lazy var firstNameInputField:FormTextField = {
        let inputField = FormTextField()
        inputField.configure(with: "First Name", text: "Yuchen")
        inputField.validation = { (inputString) -> Bool in
            inputField.errorText = "First Name is not valid"
            return inputString.count > 0
        }
        return inputField
    }()
    
    fileprivate lazy var lastNameInputField:FormTextField = {
        let inputField = FormTextField()
        inputField.configure(with: "Last Name", text: "Nie")
        return inputField
    }()
    
    fileprivate lazy var formTableView:UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        self.view.addSubview(tableView)
        return tableView
    }()
    
    override func viewWillLayoutSubviews() {
        formTableView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        super.viewWillLayoutSubviews()
    }
}

extension FormTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch fields[indexPath.row] {
        case .FirstName:
            return firstNameInputField
        case .LastName:
            return lastNameInputField
        }
    }
}
