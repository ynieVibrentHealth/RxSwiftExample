//
//  ViewController.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/1/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    enum ExampleType {
        case Textfield
        case PubSub
        case Form
        case Prefs
    }
    
    fileprivate let examples:[ExampleType] = [.Textfield, .PubSub, .Form, .Prefs]
    
    fileprivate lazy var exampleTable:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.edgesForExtendedLayout = UIRectEdge.all
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        exampleTable.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        super.viewWillLayoutSubviews()
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        switch examples[indexPath.row] {
        case .Textfield:
            cell.textLabel?.text = "Textfield"
        case .PubSub:
            cell.textLabel?.text = "Publisher Subscriber, ect..."
        case .Form:
            cell.textLabel?.text = "Form using VIP Pattern"
        case .Prefs:
            cell.textLabel?.text = "Preferences"
        }
        return cell
    }
    
    
}

extension ViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigateTo(example: examples[indexPath.row])
    }
    
    private func navigateTo(example:ExampleType) {
        switch example {
        case .Textfield:
            let textFieldEx = CitySearchExample()
            self.navigationController?.pushViewController(textFieldEx, animated: true)
        case .PubSub:
            let example = ColorPickerExample()
            self.navigationController?.pushViewController(example, animated: true)
        case .Form: /** Setting up the VIP pattern for the Form stack**/
            let example = FormStackController()
            let interactor = FormStackInteractor()
            let presenter = FormStackPresenter()
            example.output = interactor
            interactor.output = presenter
            presenter.output = example
            self.navigationController?.pushViewController(example, animated: true)
        case .Prefs:
            let example = UserPreferencesStackContainer()
            let interactor = UserPreferencesInteractor()
            let presenter = UserPreferencesPresenter()
            
            example.output = interactor
            interactor.output = presenter
            presenter.output = example
            
            self.navigationController?.pushViewController(example, animated: true)
        }
    }
}
