//
//  HTMLTextfieldExample.swift
//  RxSwiftExample
//
//  Created by Yuchen Nie on 12/14/17.
//  Copyright © 2017 Yuchen Nie. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HTMLTextfieldExample:UIViewController {
    fileprivate lazy var textView:UITextView = {
        let textView = UITextView()
        self.view.addSubview(textView)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let filepath = Bundle.main.path(forResource: "SampleHTML", ofType: "html") else {return}
        do {
            let contents = try String(contentsOfFile: filepath)
            let attributedString = NSAttributedString(html: contents)
            self.textView.attributedText = attributedString
        } catch {
            print("contents didn't work.")
        }
    }
    
    override func viewWillLayoutSubviews() {
        textView.snp.updateConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        super.viewWillLayoutSubviews()
    }
}

extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString: attributedString)
    }
}
