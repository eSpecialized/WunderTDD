//
//  WConfiguration.swift
//  WunderTDD
//
//  Created by William Thompson on 1/23/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

import UIKit

class WConfigurationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var apiTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let apiKey = WWunderAPI.getApiKey() {
            apiTextField.text = apiKey
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignFirstResponder()
        
        guard let enteredKey = textField.text, !enteredKey.isEmpty else {
            print("User didn't enter any text")
            return
        }
        
        WWunderAPI.saveApiKey(inApiKey: enteredKey)
    }
    
    
}
