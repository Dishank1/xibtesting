//
//  ViewController.swift
//  XibTesting
//
//  Created by Dishank Jhaveri on 06/09/17.
//  Copyright © 2017 Dishank Jhaveri. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum textFieldLayout: String {
        case BOXED, UNDERLINED
    }

    @IBOutlet weak var testView: TestView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        testView.setNumberOfTextFields(numberOfTextField: 4, textFieldLayout: textFieldLayout.BOXED.rawValue) // "textFieldLayout.BOXED" OR "textFieldLayout.UNDERLINED"
        testView.setBorderColor(borderColor: UIColor.blue)
        testView.setUnderlineColor(underlineColor: UIColor.red)
        testView.setTextFieldWidth(width: 50)
        testView.setTextFieldSpacing(spacing: 20)
        testView.setTextFieldHeight(height: 60)
        testView.textIsSecure(secure: false)
        testView.setBorderWidth(borderWidth: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

