#import <notify.h>

#define SETTINGS @"/var/mobile/Library/Preferences/com.naken.notificatcher.plist"

@interface PSViewController : UITableViewController
@end

@interface NotificatcherPBListController: PSViewController
@property (nonatomic, assign) BOOL appIsOn;
@property (nonatomic, strong) UITableView *mainView;
@property (nonatomic, strong) UISwitch *appSwitch;
- (void)loadSettings;
- (void)saveSettings;
- (void)like;
@end

@implementation NotificatcherPBListController

@synthesize appIsOn;
@synthesize mainView;
@synthesize appSwitch;

- (instancetype)init
{
	if ((self = [super init]))
	{
		self.title = @"Notificatcher";
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"👍" style:UIBarButtonItemStylePlain target:self action:@selector(like)];		
		mainView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStyleGrouped];
		mainView.delegate = self;
		mainView.dataSource = self;
		self.view = mainView;
		appSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
		[self loadSettings];
	}
	return self;
}

- (void)like
{
	NSString *url = @"http://bbs.iosre.com/t/ios-app-reverse-engineering-the-worlds-1st-book-of-very-detailed-ios-app-reverse-engineering-skills/1117";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return @"© 2015 snakeninny";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"any-cell"];

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.text = @"Catch";

	[self.appSwitch addTarget:self action:@selector(saveSettings) forControlEvents:UIControlEventValueChanged];	
	cell.accessoryView = self.appSwitch;
	self.appSwitch.on = self.appIsOn;

	return cell;
}

- (void)loadSettings
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:SETTINGS];
	appIsOn = [dictionary[@"appIsOn"] boolValue];
}

- (void)saveSettings
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:SETTINGS];
	self.appIsOn = self.appSwitch.on;
	dictionary[@"appIsOn"] = @(self.appIsOn);
	[dictionary writeToFile:SETTINGS atomically:YES];

	notify_post("com.naken.notificatcher.settingschanged");
}
@end
