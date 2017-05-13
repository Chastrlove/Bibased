//
//  NextViewController.h
//  DAN
//
//  Created by EMPty on 1/2/16.
//  Copyright (c) 2016 EMPty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface NextViewController : UIViewController<CBPeripheralDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) CBPeripheral *presentPeripheral;

@end
