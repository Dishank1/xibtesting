//
//  ViewController.swift
//  XibTesting
//
//  Created by Dishank Jhaveri on 06/09/17.
//  Copyright © 2017 Dishank Jhaveri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var testView: TestView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        testView.setNumberOfTextFields(numberOfTextField: 4, textFieldLayoutIs: .BOXED)
        testView.textFieldborderColorSet = UIColor.red
        testView.textFieldBorderWidth = 3
        testView.underlineColorSet = UIColor.blue
        testView.textFieldWidth = 50
        testView.textFieldHeight = 60
        testView.textfieldSpacing = 20
        testView.textIsSecure = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

