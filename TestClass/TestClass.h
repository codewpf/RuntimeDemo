//
//  TestClass.h
//  LearnRuntime
//
//  Created by wpf on 2017/2/26.
//  Copyright © 2017年 wpf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestClass : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *publicProperty1;
@property (nonatomic, copy) NSString *publicProperty2;

+ (void)classMethod:(NSString *)value;
- (void)publicTestMethod1:(NSString *)value1 second:(NSString *)value2;
- (void)publicTestMethod2;
- (void)PublicTestMethod3:(NSString *)value;

- (void)method1;


@end



@interface SubClass : TestClass

- (void)subPublicTestMethod;

@end
