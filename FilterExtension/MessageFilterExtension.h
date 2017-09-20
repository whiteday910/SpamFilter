//
//  MessageFilterExtension.h
//  FilterExtension
//
//  Created by hwi on 2017. 9. 20..
//  Copyright © 2017년 hwi. All rights reserved.
//

#import <IdentityLookup/IdentityLookup.h>
#import "SpamFilterLib.h"

@interface MessageFilterExtension : ILMessageFilterExtension
@property NSMutableArray *arr01_spamContact;
@end
