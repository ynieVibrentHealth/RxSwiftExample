//
//  CitySearchExample.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/1/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class CitySearchExample:UIViewController {
    fileprivate lazy var disposeBag:DisposeBag = {
        return DisposeBag()
    }()
    
    fileprivate lazy var searchTextField:UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.rx.text
        .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ (inputString) -> Bool in
                return !inputString.isEmpty
            })
            .subscribe(onNext: { [unowned self] (inputString) in
                self.shownCities = self.availableCities.filter { $0.hasPrefix(inputString) } // We now do our "API Request" to find cities.
                self.resultsTable.reloadData() // And reload table view data.
            }).disposed(by: self.disposeBag)
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var resultsTable:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    fileprivate lazy var dividerLine:UIView = {
        let view = UIView()
        self.view.addSubview(view)
        view.backgroundColor = .lightGray
        return view
    }()
    
    var shownCities = [String]()
    
    var availableCities:[String] = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    
    override func viewWillLayoutSubviews() {
        searchTextField.snp.updateConstraints { (make) in
            make.top.equalTo(self.view)
            make.leading.trailing.equalTo(self.view).inset(15)
            make.height.equalTo(44)
        }
        
        dividerLine.snp.updateConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(searchTextField.snp.bottom)
            make.height.equalTo(1)
        }
        
        resultsTable.snp.updateConstraints { (make) in
            make.top.equalTo(dividerLine.snp.bottom).offset(1)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        super.viewWillLayoutSubviews()
    }
}

extension CitySearchExample:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell(style: .default, reuseIdentifier: "CitySearchExampleCell")
        tableCell.textLabel?.text = shownCities[indexPath.row]
        return tableCell
    }
}
