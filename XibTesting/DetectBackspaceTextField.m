//
//  DetectBackspaceTextField.m
//  AccountManagement
//
//  Created by Alexey Potapov on 10/22/15.
//  Copyright © 2015 Liberty Wireless Ltd. All rights reserved.
//

#import "DetectBackspaceTextField.h"

@implementation DetectBackspaceTextField

- (void)deleteBackward {
    [super deleteBackward];
    
    if ([_backspaceDelegate respondsToSelector:@selector(textFieldDidDelete:)]){
        [_backspaceDelegate textFieldDidDelete:self];
    }
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

@end
