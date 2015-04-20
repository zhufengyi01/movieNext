//
//  netRequest.m
//  movienext
//
//  Created by 风之翼 on 15/4/17.
//  Copyright (c) 2015年 redianying. All rights reserved.
//

#import "netRequest.h"
#import "Constant.h"
@implementation netRequest


//举报剧情
-(int)requestReportSatgeWithParametes:(NSDictionary *)parameters
{
//    
//    NSMutableString  *code;
//        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//        [manager POST:[NSString stringWithFormat:@"%@/report-stage/create", kApiBaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            if ([[responseObject  objectForKey:@"code"]  intValue]==0) {
////                UIAlertView  *Al =[[UIAlertView alloc]initWithTitle:nil message:@"你的举报已成功,我们会在24小时内处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                [Al show];
//                //code=[responseObject objectForKey:@"code"];
//                code=[NSMutableString stringWithString:[responseObject objectForKey:@"code"]];
//             }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Error: %@", error);
//        }];
    return 0;
}
@end
