//
//  ViewController.m
//  test
//
//  Created by Gaurav on 02/09/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "FMDatabase.h"
#import "MyTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource> {
    YTPlayerView *objPlayerView;
}

@property(nonatomic,weak) IBOutlet UITableView *tblView;

@end

@implementation ViewController
@synthesize tblView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self callPostMethod];
}

-(void)callGetMethod {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://apidev.accuweather.com/currentconditions/v1/202438.json?language=en&apikey=hoArfRosT1215"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@", responseObject);
            NSArray *arrayCategories = (NSArray*)responseObject;
            NSDictionary *dic = [arrayCategories objectAtIndex:0];
            NSLog(@"%@",dic);
            
            NSDictionary *tempDic = [dic objectForKey:@"Temperature"];
            NSLog(@"%@",tempDic);
            
            NSDictionary *metic = [tempDic objectForKey:@"Metric"];
            NSLog(@"value =%@",[metic objectForKey:@"Value"]);
            
        }
    }];
    [dataTask resume];

}

-(void)callPostMethod {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    NSString *URLString = @"http://date.jsontest.com/";
    NSDictionary *parameters = [NSDictionary dictionaryWithObject:@"cb784502bffab6e" forKey:@"key"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
  //  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        [activityView stopAnimating];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@", responseObject);
            NSDictionary *responseDic = responseObject;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
            NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"/MyDate.db"];

            FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
            
            if (![db open]) {
                // [db release];   // uncomment this line in manual referencing code; in ARC, this is not necessary/permitted
                db = nil;
                return;
            }
            
            NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO MyDate(mydateinfo, mymilsecondinfo, mytimeinfo) VALUES (\"%@\",\"%@\",\"%@\");",[responseDic objectForKey:@"date"],
                                     [responseDic objectForKey:@"milliseconds_since_epoch"],
                                     [responseDic objectForKey:@"time"]];
            
            BOOL getIt= [db executeUpdate:insertQuery];
                         
                         
            [db close];
            if(getIt)
            {
                NSLog(@"inserted");
            }
            
            [self getDataFromDB];
        }
    }];
    [dataTask resume];

    
}

-(void)getDataFromDB {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"/MyDate.db"];
    
    FMDatabase* db = [FMDatabase databaseWithPath:dbPath];
    
    if(![db open])
        NSLog(@"database can not be open...");
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM MyDate"];
   
    while ([rs next]) {
        NSLog(@"date=%@",[rs stringForColumn:@"mydateinfo"]);
        NSLog(@"milli=%@",[rs stringForColumn:@"mymilsecondinfo"]);
        NSLog(@"time=%@",[rs stringForColumn:@"mytimeinfo"]);
    }
    
    [db close];
    
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblLabel.text=[NSString stringWithFormat:@"test %ld",(long)indexPath.row];
    cell.lblDesc.text=[NSString stringWithFormat:@"desc %ld",(long)indexPath.row];
    //
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imgView];
    
    [cell.imgView setImageURL:[NSURL URLWithString:@"http://charcoaldesign.co.uk/AsyncImageView/Forest/IMG_0351.JPG"]];
    
  /*  MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    
    if (cell==nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.lblLabel.text=[NSString stringWithFormat:@"test %ld",(long)indexPath.row];
    cell.lblDesc.text=[NSString stringWithFormat:@"desc %ld",(long)indexPath.row];
    //
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:cell.imgView];

    [cell.imgView setImageURL:[NSURL URLWithString:@"http://charcoaldesign.co.uk/AsyncImageView/Forest/IMG_0351.JPG"]];*/
    
 /*   static NSString *reuseIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    cell.textLabel.text=[NSString stringWithFormat:@"test %d",indexPath.row];*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    AVPlayerViewController * _moviePlayer1 = [[AVPlayerViewController alloc] init];
//    _moviePlayer1.player = [AVPlayer playerWithURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=pX53bOO-6ak"]];
//    
//    //https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
//    [self presentViewController:_moviePlayer1 animated:YES completion:^{
//        [_moviePlayer1.player play];
//    }];
    NSString *url = @"https://www.youtube.com/watch?v=pX53bOO-6ak";
    
    NSArray *strUrl = [url componentsSeparatedByString:@"?v="];
    NSString *videoid = [strUrl objectAtIndex:1];
    
    if (!objPlayerView) {
        objPlayerView = [[YTPlayerView alloc] initWithFrame:CGRectMake(0, 0, 200,  200)];
    }
    [objPlayerView setHidden:NO];
    [self.view addSubview:objPlayerView];

     [objPlayerView loadWithVideoId:videoid];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
