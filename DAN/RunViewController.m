//
//  RunViewController.m
//  xyz
//
//  Created by Jay on 2017/3/30.
//  Copyright © 2017年 EMPty. All rights reserved.
//

#import "RunViewController.h"
#import "NextViewController.h"

@interface RunViewController ()
{
    UITableView* _tableView;
    UIView * _tarBar;
    
}
@property (strong, nonatomic) CBCentralManager *centralManger;
@property (strong, nonatomic) CBPeripheral *chosenPeripheral;

@property (strong, nonatomic) NSMutableArray *peripherals;

@end

@implementation RunViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [self viewDidLoad];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peripherals = [[NSMutableArray alloc]initWithObjects: nil];
    
    self.centralManger = [[CBCentralManager alloc] initWithDelegate:self
                                                              queue:nil];
//设置导航颜色的方法（不推荐）
//    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 62, 20)] ;
//
//    titleLabel.text = @"运动社交";
//    titleLabel.textColor= [UIColor whiteColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    self.navigationItem.titleView = titleLabel;
    self.navigationItem.title = @"运动社交";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    [self initTableView];
    [self initTarBar];
      
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.centralManger scanForPeripheralsWithServices:nil
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
        NSLog(@">>>BLE状态正常");
    }else{
        NSLog(@">>>设备不支持BLE或者未打开");
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    if (![_peripherals containsObject:peripheral]) {
        [_peripherals addObject:peripheral];
        [_tableView reloadData];
    }
    
    
}

- (void)initTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20 - self.navigationController.navigationBar.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
     self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:_tableView];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peripherals.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"1"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"1"];
        
    }
    CBPeripheral *peripheral = self.peripherals[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"名称：%@",peripheral.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"ID:%@",[peripheral.identifier UUIDString]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral *peripheral = self.peripherals[indexPath.row];
    NSLog(@"选中了%@",peripheral.name);
    [NSThread detachNewThreadSelector:@selector(connect:) toTarget:self withObject:peripheral];
    
    
}

- (void)initTarBar
{
    _tarBar = [[UIView alloc]initWithFrame:CGRectMake(_tableView.bounds.origin.x, _tableView.frame.origin.y + _tableView.frame.size.height - 49, _tableView.frame.size.width, 50)];
    [self.view addSubview:_tarBar];
    UIButton * scan = [[UIButton alloc]initWithFrame:_tarBar.bounds];
    [_tarBar addSubview:scan];
    scan.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:127.0/255.0 blue:0.0/255.0 alpha:1.0];
    [scan addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
    [scan setTitle:@"重新扫描" forState:UIControlStateNormal];
    //[scan setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [scan setTintColor:[UIColor redColor]];
    
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"连接提示" message:[NSString stringWithFormat:@"无法连接到%@",peripheral.name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"连接提示" message:[NSString stringWithFormat:@"已连接上%@",peripheral.name] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
}


- (void)scan
{
    NSLog(@"重新扫描");
    [self viewDidLoad];
}

//连接指定的设备
-(BOOL)connect:(CBPeripheral *)peripheral
{
    //连接的时候停止扫描
    [_centralManger stopScan];
    NSLog(@"connect start");
    //    self.chosenPeripheral = [CBCharacteristic alloc]ini
    self.chosenPeripheral = peripheral;
    [self.centralManger connectPeripheral:self.chosenPeripheral
                                  options:nil];
    peripheral.delegate = self;
    [NSThread sleepForTimeInterval:1.0];
    [self performSelectorOnMainThread:@selector(update:) withObject:peripheral waitUntilDone:YES];
    
    return (YES);
}

- (void)update:(CBPeripheral *)peripheral
{
    NextViewController *detailBlueToothView = [[NextViewController alloc]init];
    detailBlueToothView.presentPeripheral = peripheral;
    [self.navigationController pushViewController:detailBlueToothView animated:YES];
}
@end

