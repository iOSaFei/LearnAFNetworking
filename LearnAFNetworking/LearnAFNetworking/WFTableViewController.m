//
//  WFTableViewController.m
//  LearnAFNetworking
//
//  Created by iOS-aFei on 16/9/20.
//  Copyright © 2016年 iOS-aFei. All rights reserved.
//

#import "WFTableViewController.h"
#import "AFNetworking.h"

@interface WFTableViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation WFTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = @[
                   @"1、使用NSURLSesscion进行GET请求",
                   @"2、使用NSURLSesscion进行POST请求",
                   @"3、使用AFNetworking请求json数据",
                   @"4、使用AFNetworking请求非json数据",
                   ];
    self.tableView.rowHeight = 70.0f;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"TableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellID];
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /**
     *  @author iOS-aFei, 16-09-21 15:09:51
     *  AFNetworking 默认接收 json 格式的响应，而且会自动解析
     *  如果想要返回 html，需要设置 acceptableContentTypes
     */
    if (indexPath.row == 0) {
        [self requestUseNSURLSesscionGET];
    } else if (indexPath.row == 1) {
        [self requestUseNSURLSesscionPOST];
    } else if (indexPath.row == 2) {
        [self requestJsonUseAFNetworking];
    } else if (indexPath.row == 3) {
        [self requestOtherUseAFNetworking];
    }
}
- (void)requestUseNSURLSesscionGET {
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
//  也可以根据代理方法请求 需要遵循NSURLSessionDataDelegate
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@---%d",[NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:nil],[[NSThread currentThread] isMainThread]);
    }];
//    通过打印可以看出回调方法在子线程中调用，如果在回调方法中拿到数据刷新UI，必须要回到主线程刷新UI。
    [dataTask resume];
}
- (void)requestUseNSURLSesscionPOST {
    NSURL *url = [NSURL URLWithString:@"http://120.25.226.186:32812/login"];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=520it&pwd=520it&type=JSON" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:nil]);
    }];
    [dataTask resume];
}
- (void)requestJsonUseAFNetworking {
    NSString *URLString = @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=json&ip=218.4.255.255";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager GET:URLString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) { NSLog(@"%@" ,responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { NSLog(@"%@", error);
         }
     ];
}
- (void)requestOtherUseAFNetworking {
    NSString *URLString = @"http://ip.taobao.com/service/getIpInfo.php?ip=63.223.108.42";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain" ,@"application/json", @"text/json", @"text/javascript",@"text/html",@"image/png",@"image/jpeg",@"application/rtf",@"image/gif",@"application/zip",@"audio/x-wav",@"image/tiff",@" application/x-shockwave-flash",@"application/vnd.ms-powerpoint",@"video/mpeg",@"video/quicktime",@"application/x-javascript",@"application/x-gzip",@"application/x-gtar",@"application/msword",@"text/css",@"video/x-msvideo",@"text/xml", nil];
    [manager GET:URLString
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) { NSLog(@"%@" ,responseObject);
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { NSLog(@"%@", error);
         }
     ];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
