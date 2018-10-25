//
//  WConfiguration.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class WConfigurationViewController: UIViewController {

    @IBOutlet weak var apiTextField: UITextField!
  
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiKey = WWunderAPI.getApiKey()
        apiTextField.text = apiKey
        
        apiTextField.rx
        .controlEvent(UIControlEvents.editingDidBegin)
        .subscribe(onNext: { [weak self] _ in
            self?.apiTextField.becomeFirstResponder()
        })
        .disposed(by: bag)
      
        apiTextField.rx
        .controlEvent(UIControlEvents.editingDidEndOnExit)
        .filter { [weak self] _ in
            self?.apiTextField.text?.count == 16 }
        .subscribe(onNext: { [weak self] _ in
            self?.resignFirstResponder()
            guard let enteredKey = self?.apiTextField.text else {
                return
            }
            WWunderAPI.saveApiKey(inApiKey: enteredKey)
        })
        .disposed(by: bag)
        
    }
    
}

