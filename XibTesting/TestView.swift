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
    
    enum textFieldLayout: String {
        case BOXED, UNDERLINED
    }
    
    @IBOutlet var contentView: UIView!
    var arrayOfTextFields : [DetectBackspaceTextField] = []
    var arrayOfUnderline : [UIView] = []
    
    var posX : Int = 0
    var posY : Int = 0
    
    var isBoxedEnabled : Bool = false
    var isUnderlineEnabled : Bool = false
    
    let dummyTextField = DetectBackspaceTextField()
    @IBOutlet weak var touchInterceptorView: UIView!
    
    var textFieldWidth : Int = TextfieldConstants.textFieldWidth{
        didSet {
            setTextFieldWidth()
        }
    }
    var textFieldHeight : Int = TextfieldConstants.textFieldHeight{
        didSet{
            setTextFieldHeight()
        }
    }
    var textfieldSpacing : Int = TextfieldConstants.textFieldSpacing{
        didSet{
            setTextFieldSpacing()
        }
    }
    
    var textIsSecure: Bool = false{
        didSet{
            setTextIsSecure()
        }
    }
    
    var textFieldborderColorSet = UIColor.clear{
        didSet{
            setBorderColor()
        }
    }
    var underlineColorSet = UIColor.clear{
        didSet{
            setUnderlineColor()
        }
    }
    var textFieldBorderWidth : CGFloat = 1 {
        didSet{
            setBorderWidth()
        }
    }
    
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
    
    //MARK: - SETTERS
    
    public func setTextFieldHeight(){
        updateTextField()
        invalidateIntrinsicContentSize()
    }
    
    public func setTextFieldWidth(){
        updateTextField()
        invalidateIntrinsicContentSize()
    }
    
    public func setTextFieldSpacing(){
        updateTextfieldSpacing()
        invalidateIntrinsicContentSize()
    }
    
    private func setBorderColor(){
        if isBoxedEnabled {
            updateBorderColor()
        }
    }
    
    public func setBorderWidth(){
        updateBorderWidth()
    }
    
    public func setUnderlineColor(){
        if isUnderlineEnabled {
            updateUnderlineColor()
        }
    }
    
    private func setTextIsSecure(){
        if textIsSecure {
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
    
    /**
     - Parameter numberOfTextField:   Number of fields to be displayed.
     - Parameter textFieldLayoutIs: boxed/underlined.
     */
    public func setNumberOfTextFields(numberOfTextField:Int, textFieldLayoutIs:textFieldLayout){
        for i in 0...numberOfTextField-1 {
            let textField = DetectBackspaceTextField(frame: CGRect(x: posX + (textFieldWidth*i) + (textfieldSpacing*i), y: posY, width: textFieldWidth, height: textFieldHeight))
            
            let underline = UIView(frame: CGRect(x: posX + (textFieldWidth*i) + (textFieldHeight*i), y: posY + textFieldHeight, width: textFieldWidth, height: 1))
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
        
        switch textFieldLayoutIs {
        case .BOXED:
            isBoxedEnabled = true
            setupTextfieldLayoutToBoxed()
            break
        case .UNDERLINED:
            isUnderlineEnabled = true
            setupTextfieldLayoutToUnderlined()
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
    
    //MARK: - Update Textfield Properties
    
    private func updateTextfieldSpacing() {
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
            textField.layer.borderColor = textFieldborderColorSet.cgColor
        }
    }
    
    private func updateUnderlineColor(){
        for underline in arrayOfUnderline{
            underline.backgroundColor = underlineColorSet
        }
    }
    
    /**
     Update textfield height and width.
    */
    private func updateTextField(){
        for textField in arrayOfTextFields{
            let newSize = CGSize(width: textFieldWidth, height:  textFieldHeight)
            let newFrame = CGRect(origin: textField.frame.origin, size: newSize)
            textField.frame = newFrame
        }
        if isUnderlineEnabled {
            for underline in arrayOfUnderline{
                let newFrame = CGRect(x: underline.frame.origin.x, y: CGFloat(posY + textFieldHeight), width: CGFloat(textFieldWidth), height: 1)
                underline.frame = newFrame
            }
        }
    }
    
    private func updateBorderWidth(){
        if isBoxedEnabled {
            for textField in arrayOfTextFields{
                textField.layer.borderWidth = textFieldBorderWidth
            }
        }
    }
    
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
    
    //MARK: - Setup Appearance/Layout

    func setupTextfieldLayoutToBoxed() {
        for textfield in arrayOfTextFields{
            textfield.layer.borderColor = textFieldborderColorSet.cgColor
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
        
        return CGSize(width: (textFieldTotalWidth + spacingTotalWidth), height: CGFloat(textFieldHeight + TextfieldConstants.underLineHeight))
    }
    
}
