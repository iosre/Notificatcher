#include <substrate.h>
#include <objc/runtime.h>
#include <notify.h>

#define SETTINGS @"/var/mobile/Library/Preferences/com.naken.notificatcher.plist"

@interface NSConcreteNotification : NSNotification
@end

static BOOL appIsOn = YES;

%hook CPDistributedMessagingCenter
- (BOOL)_sendMessage:(id)arg1 userInfo:(id)arg2 receiveReply:(id)arg3 error:(id)arg4 toTarget:(id)arg5 selector:(SEL)arg6 context:(void*)arg7 nonBlocking:(BOOL)arg8
{
	BOOL result = %orig;
	if (appIsOn) NSLog(@"catcher: [CPDistributedMessagingCenter _sendMessage:%@ userInfo:%@ receiveReply:%@ error:%@ toTarget:%@ selector:%s context:%@ nonBlocking:%@]", arg1, arg2, arg3, arg4, arg5, sel_getName(arg6), arg7, @((BOOL)arg8));
	return result;
}
%end

static uint32_t (*old_notify_post)(const char *name);

static uint32_t new_notify_post(const char *name)
{
	uint32_t result = old_notify_post(name);
	if (appIsOn) NSLog(@"catcher: notify_post(%s)", name);
	return result;
}

extern "C" void _CFXNotificationPost(CFNotificationCenterRef center, NSConcreteNotification *notification, Boolean deliverImmediately);

static void (*old__CFXNotificationPost)(CFNotificationCenterRef center, NSConcreteNotification *notification, Boolean deliverImmediately);

static void new__CFXNotificationPost(CFNotificationCenterRef center, NSConcreteNotification *notification, Boolean deliverImmediately)
{
	old__CFXNotificationPost(center, notification, deliverImmediately);
	if (appIsOn) NSLog(@"catcher: _CFXNotificationPost(%@)", notification);
}

static void LoadSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:SETTINGS];
	appIsOn = [(NSNumber *)[dictionary objectForKey:@"appIsOn"] boolValue];
}

static void InitializeSettings(void)
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:SETTINGS]) [@{@"appIsOn" : @0} writeToFile:SETTINGS atomically:YES];
	LoadSettings(nil, nil, nil, nil, nil);
}

%ctor
{

	InitializeSettings();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, LoadSettings, CFSTR("com.naken.notificatcher.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	MSHookFunction(notify_post, new_notify_post, &old_notify_post);
	MSHookFunction(_CFXNotificationPost, new__CFXNotificationPost, &old__CFXNotificationPost);	
}
