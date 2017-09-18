//
//  DetectBackspaceTextField.h
//  AccountManagement
//
//  Created by Alexey Potapov on 10/22/15.
//  Copyright © 2015 Liberty Wireless Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetectBackspaceDelegate <NSObject>
@optional
- (void)textFieldDidDelete:(UITextField *) textField;
@end

@interface DetectBackspaceTextField : UITextField

@property (nonatomic, assign) id<DetectBackspaceDelegate> backspaceDelegate;

@end
