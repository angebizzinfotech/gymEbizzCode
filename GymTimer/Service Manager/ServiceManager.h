//
//  ServiceManager.h
//  GymTimer
//
//  Created by EbitNHP-i1 on 16/04/19.
//  Copyright © 2019 EbitNHP-i1. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//MARK:- Service manager delegate
@protocol ServiceManagerDelegate <NSObject>

-(void)webServiceCallSuccess:(id)response forTag:(NSString *)tagname;
-(void)webServiceCallFailure:(NSError *)error forTag:(NSString *)tagname;

@end


@interface ServiceManager : NSObject

@property (nonatomic, weak) id<ServiceManagerDelegate> delegate;
+ (ServiceManager *)sharedManager;

-(void)callWebServiceWithGet:(NSString *)webpath withTag:(NSString *)tagname params:(NSArray *)params;
-(void)callWebServiceWithPOST:(NSString *)webpath withTag:(NSString *)tagname params:(NSArray *)params;
-(void) callWebServiceWithPOST: (NSString *) webpath withTag: (NSString *) tagname paramsDic: (NSDictionary *) params;
- (void)callWebServiceWithPOSTForImageUpload:(NSString *)webpath withTag:(NSString *)tagname params:(NSArray *)params imgArray:(NSMutableArray *)arrImages;

@end

NS_ASSUME_NONNULL_END
