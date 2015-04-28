//
//  ViewController.m
//  MiDaiPay
//
//  Created by wr on 15/3/17.
//  Copyright (c) 2015年 WR. All rights reserved.
//

#import "ViewController.h"
#import "findPhoneIPNumber.h"
@interface ViewController ()
{


}


@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *userPassWordTextfield;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)LoginButton:(UIButton *)sender {
    
    [self loadData];
    [self performSegueWithIdentifier:@"LoginViewController" sender:nil];

}
- (IBAction)RegisterButton:(UIButton *)sender {
    
    
    [self performSegueWithIdentifier:@"RegisterViewController" sender:nil];
}


-(void)loadData
{
    //内层存放需要的content中的信息内容
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:0];
    //外层存放需要的code和content分别的信息内容
    NSMutableDictionary * contentDic = [NSMutableDictionary dictionaryWithCapacity:0];
    //    [dic setObject:self.userNameTextField.text forKey:@"PHONENUMBER"];
    //    [dic setObject:self.userPassWordTextfield.text forKey:@"PASSWORD"];
    [dic setObject:@"15900715775" forKey:@"PHONENUMBER"];
    [dic setObject:@"123456" forKey:@"PASSWORD"];
    NSString * phoneIPAddress = [findPhoneIPNumber getPhoneIPAddress];
    [dic setObject:phoneIPAddress forKey:@"IP"];
    [contentDic setObject:CodeLoginRequestNumberStr forKey:@"code"];
    [contentDic setObject:[NSString stringWithFormat:@"%@",dic] forKey:@"content"];

    
    //POST请求
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //否则会返回错误信息
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes  setByAddingObject:@"text/html"];
    [manager POST:HttpRequestUrl parameters:contentDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求成功跳转页面
        [self performSegueWithIdentifier:@"LoginViewController" sender:nil];
        NSLog(@"请求完成 %@",responseObject);
        //接收返回的信息
        NSDictionary * receiveMessageDic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        [receiveMessageDic objectForKey:@"RSPCOD"];
        [receiveMessageDic objectForKey:@"RSPMSG"];
        [receiveMessageDic objectForKey:@"STATE"];
      
        NSArray * receiveMessageArray = [NSArray arrayWithObjects:[receiveMessageDic objectForKey:@"RSPCOD"],[ViewController replaceUnicode:[receiveMessageDic objectForKey:@"RSPMSG"]],[receiveMessageDic objectForKey:@"STATE"], nil];
        NSLog(@"%@ ~~%@",receiveMessageDic,receiveMessageArray);
           
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败%@",error);
    }];
    
    
    
//    //第二种方式表单式提交
//    [manager POST:@"" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //这里传递参数
//        UIImage*image=[UIImage imageNamed:@"1.jpg"];
//        //第一种方式传递二进制数据 image是服务器指定的key
//        [formData appendPartWithFormData:UIImagePNGRepresentation(image) name:@"image"];
//        //第二种方式传递一个路径
//        NSString*path=[NSString stringWithFormat:@"%@/Documents/1.jpg",NSHomeDirectory()];
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"image" error:nil];
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"请求成功");
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败");
//    }];
  
}
#pragma mark - 转码

// NSString值为Unicode格式的字符串编码(如\u7E8C)转换成中文
//unicode编码以\u开头
+ (NSString *)replaceUnicode:(NSString *)unicodeStr

{

    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];

    NSLog(@"%@",returnStr);
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}


+ (NSString*)UTF8_To_GB2312:(NSString*)utf8string
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [utf8string dataUsingEncoding:encoding];
    return [[NSString alloc] initWithData:gb2312data encoding:encoding] ;
}

#pragma mark - 收回键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
