//
//  TestView.swift
//  XibTesting
//
//  Created by Dishank Jhaveri on 06/09/17.
//  Copyright © 2017 Dishank Jhaveri. All rights reserved.
//

import UIKit

class TestView: UIView,UITextFieldDelegate,DetectBackspaceDelegate {
    
    private struct TextfieldConstants {
        static let textFieldWidth: Int              = 40
        static let textFieldHeight: Int             = 50
        static let textFieldSpacing: Int            = 16
        static let textFieldMaxTextLength: Int      = 1
        static let underLineHeight: Int             = 1
    }
    
    @IBOutlet var contentView: UIView!
    var arrayOfTextFields : [DetectBackspaceTextField] = []
    var arrayOfUnderline : [UIView] = []
    
    var posX : Int = 0
    var posY : Int = 0
    var textFieldWidth : Int = TextfieldConstants.textFieldWidth
    var textFieldHeight : Int = TextfieldConstants.textFieldHeight
    var textfieldSpacing : Int = TextfieldConstants.textFieldSpacing
    var isBoxedEnabled : Bool = false
    var isUnderlineEnabled : Bool = false
    
    let dummyTextField = DetectBackspaceTextField()
    @IBOutlet weak var touchInterceptorView: UIView!
    
    var textFieldborderColorSet = UIColor.clear.cgColor
    var underlineColorSet = UIColor.clear
    var textFieldBorderWidth : CGFloat = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("TestView", owner: self, options: nil)
        addSubview(contentView)
        addSubview(touchInterceptorView)
        
        dummyTextField.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(requestFirstResponse))
        touchInterceptorView.addGestureRecognizer(tapGesture)
    }
    
    public func setTextFieldHeight( height : Int){
        textFieldHeight = height
        updateTextField()
        invalidateIntrinsicContentSize()
    }
    
    public func setTextFieldWidth( width : Int){
        textFieldWidth = width
        updateTextField()
        invalidateIntrinsicContentSize()
    }
    
    public func setTextFieldSpacing( spacing : Int){
        textfieldSpacing = spacing
        updateTextfieldSpacing()
        invalidateIntrinsicContentSize()
    }
    
    public func setBorderColor(borderColor: UIColor){
        textFieldborderColorSet = borderColor.cgColor
        updateBorderColor()
    }
    
    public func setBorderWidth(borderWidth: CGFloat){
        textFieldBorderWidth = borderWidth
        updateBorderWidth()
    }
    
    public func setUnderlineColor(underlineColor: UIColor){
        underlineColorSet = underlineColor
        updateUnderlineColor()
    }
    
    public func setNumberOfTextFields(numberOfTextField:Int, textFieldLayout: String){
        for i in 0...numberOfTextField-1 {
            let textField = DetectBackspaceTextField(frame: CGRect(x: posX + (textFieldWidth*i) + (textfieldSpacing*i), y: posY, width: textFieldWidth, height: textFieldHeight))
            
            let underline = UIView(frame: CGRect(x: posX + (textFieldWidth*i) + (textFieldHeight*i), y: posY + textFieldHeight, width: textFieldWidth, height: 1))
            print("posY \(posY) textfieldHeight \(textFieldHeight)")
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            
            textField.delegate = self
            textField.backspaceDelegate = self
            //textField.placeholder = "\(i+1)"
            setupTextFieldAppearance(textField)
            
            arrayOfTextFields.append(textField)
            arrayOfUnderline.append(underline)
            
            contentView.addSubview(textField)
            contentView.addSubview(underline)
        }
        
        switch textFieldLayout {
        case "BOXED":
            isBoxedEnabled = true
            setupTextfieldLayoutToBoxed()
            break
        case "UNDERLINED":
            isUnderlineEnabled = true
            setupTextfieldLayoutToUnderlined()
            break
        default:
            isBoxedEnabled = true
            setupTextfieldLayoutToBoxed()
            break
        }
        
        setupTextFieldAppearance(dummyTextField)
        arrayOfTextFields.append(dummyTextField)
        contentView.addSubview(dummyTextField)
        dummyTextField.delegate = self
        dummyTextField.backspaceDelegate = self
        dummyTextField.autocorrectionType = .no
        
        invalidateIntrinsicContentSize()
    }
    
    func getValue() -> String {
        var myString = ""
        for i in 0...arrayOfTextFields.count-2{
            myString.append(arrayOfTextFields[i].text!)
        }
        return myString
    }
    
    func clear() {
        for i in 0...arrayOfTextFields.count-1{
            arrayOfTextFields[i].text = ""
        }
        arrayOfTextFields[0].becomeFirstResponder()
    }
    
    public func requestFirstResponse(){
        for i in 0...arrayOfTextFields.count-2{
            if(arrayOfTextFields[i].text?.isEmpty)!{
                arrayOfTextFields[i].becomeFirstResponder()
                break
            }
        }
    }
    
    func updateTextfieldSpacing() {
        for i in 0...arrayOfTextFields.count-2{
            var textFieldFrame:CGRect = arrayOfTextFields[i].frame
            textFieldFrame.origin.x = CGFloat(posX + (textFieldWidth*i) + (textfieldSpacing*i))
            arrayOfTextFields[i].frame = textFieldFrame
            
            var underlineFrame:CGRect = arrayOfUnderline[i].frame
            underlineFrame.origin.x = CGFloat(posX + (textFieldWidth*i) + (textfieldSpacing*i))
            arrayOfUnderline[i].frame = underlineFrame
        }
    }
    
    private func updateBorderColor(){
        for textField in arrayOfTextFields{
            textField.layer.borderColor = textFieldborderColorSet
        }
    }
    
    private func updateUnderlineColor(){
        for underline in arrayOfUnderline{
            underline.backgroundColor = underlineColorSet
        }
    }
    
    public func textIsSecure(secure : Bool){
        if secure {
            for textfield in arrayOfTextFields{
                textfield.isSecureTextEntry = true
            }
        }
        else{
            for textfield in arrayOfTextFields{
                textfield.isSecureTextEntry = false
            }
        }
    }
    
    private func updateTextField(){
        for textField in arrayOfTextFields{
            let newSize = CGSize(width: textFieldWidth, height:  textFieldHeight)
            let newFrame = CGRect(origin: textField.frame.origin, size: newSize)
            textField.frame = newFrame
        }
        for underline in arrayOfUnderline{
            let newFrame = CGRect(x: underline.frame.origin.x, y: CGFloat(posY + textFieldHeight), width: CGFloat(textFieldWidth), height: 1)
            underline.frame = newFrame
        }
    }
    
    private func updateBorderWidth(){
        for textField in arrayOfTextFields{
            textField.layer.borderWidth = textFieldBorderWidth
        }
    }
//    
//    private func updateFontsize{
//        for textField in arrayOfTextFields{
//            textField.font
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidDelete(_ textField: UITextField) {
        for i in 1...arrayOfTextFields.count-1{
            if(arrayOfTextFields[i] == textField && (textField.text?.isEmpty)!){
                arrayOfTextFields[i-1].text = ""
                arrayOfTextFields[i-1].becomeFirstResponder()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField.text!.characters.count >= TextfieldConstants.textFieldMaxTextLength  && !(string.isEmpty)){
            return false
        }
        else{
            return true
        }
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if (textField.text!.characters.count >= TextfieldConstants.textFieldMaxTextLength){
            for i in 0...arrayOfTextFields.count-1{
                if(arrayOfTextFields[i] == textField && (i+1) < arrayOfTextFields.count){
                    arrayOfTextFields[i+1].becomeFirstResponder()
                }
            }
        }
    }
    
    func setupTextfieldLayoutToBoxed() {
        for textfield in arrayOfTextFields{
            textfield.layer.borderColor = textFieldborderColorSet
            textfield.layer.cornerRadius = 4
            textfield.layer.borderWidth = textFieldBorderWidth
        }
        hideUnderline()
    }
    
    func setupTextfieldLayoutToUnderlined() {
        hideUnderline()
    }
    
    func hideUnderline(){
        for underline in arrayOfUnderline{
            if(isUnderlineEnabled){
                underline.isHidden = false
            }
            else{
                underline.isHidden = true
            }
        }
    }
    
    func setupTextFieldAppearance(_ textField: UITextField) {
        textField.borderStyle = UITextBorderStyle.none
        textField.tintColor = UIColor.clear
        textField.isSecureTextEntry = true
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textAlignment = .center
    }
    
    override var intrinsicContentSize: CGSize {
        let textFieldTotalWidth = CGFloat(textFieldWidth) * CGFloat(arrayOfTextFields.count-1)
        let spacingTotalWidth = CGFloat(textfieldSpacing * (arrayOfTextFields.count - 2))
        print("\(textFieldHeight)")
        
        return CGSize(width: (textFieldTotalWidth + spacingTotalWidth), height: CGFloat(textFieldHeight + TextfieldConstants.underLineHeight))
    }
    
}
