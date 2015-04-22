//
//  RadioButton.swift
//  Yelp
//
//  Created by John YS on 4/21/15.
//  Copyright (c) 2015 John YS. All rights reserved.
//
// Code borrowed from: http://pjeremymalouf.com/radio-button-functionality-in-swift/

import UIKit

class RadioButton: UIButton {
    var myAlternateButton:Array<RadioButton>?
    
    var downStateImage:String? = "check-circle.png"{
        
        didSet{
            
            if downStateImage != nil {
                
                self.setImage(UIImage(named: downStateImage!), forState: UIControlState.Selected)
            }
        }
    }
    
    func unselectAlternateButtons(){
        
        if myAlternateButton != nil {
            
            self.selected = true
            
            for aButton:RadioButton in myAlternateButton! {
                
                aButton.selected = false
            }
            
        }else{
            
            toggleButton()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        unselectAlternateButtons()
        super.touchesBegan(touches, withEvent: event)
    }
    
    func toggleButton(){
        
        if self.selected==false{
            
            self.selected = true
        }else {
            
            self.selected = false
        }
    }
}
