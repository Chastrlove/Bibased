//
//  ChatViewController.m
//  运动社交
//
//  Created by Jay on 2017/4/5.
//  Copyright © 2017年 Jay. All rights reserved.
//

#import "ChatViewController.h"
#import "freindViewController.h"
@interface ChatViewController ()

@end

@implementation ChatViewController

-(id)init{
    self = [super init];
    if(self){
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                              @(ConversationType_GROUP)]];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    self.hidesBottomBarWhenPushed = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    self.hidesBottomBarWhenPushed = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initfrindButton];
    self.navigationItem.title = @"聊天";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    // Do any additional setup after loading the view.
}
- (void)initfrindButton
{
    //    UIButton* codebutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //    [codebutton setImage:[UIImage imageNamed:@"code.png"] forState:UIControlStateNormal];
    //    [codebutton addTarget:self action:@selector(codeAction) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:codebutton];//为导航栏左侧添加系统自定义按钮
    
    UIButton* chartbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [chartbutton setImage:[UIImage imageNamed:@"addFriend.png"] forState:UIControlStateNormal];
    [chartbutton addTarget:self action:@selector(addfreind) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:chartbutton];//为导航栏右侧添加系统自定义按钮
    
}
- (void)addfreind{
    NSLog(@"进入通讯录");
    freindViewController* scan = [[freindViewController alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.title = [NSString stringWithFormat:@"来自%@的对话",model.conversationTitle];
    [self.navigationController pushViewController:conversationVC animated:YES];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
