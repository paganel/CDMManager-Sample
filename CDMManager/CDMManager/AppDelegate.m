//
//  AppDelegate.m
//  CDMManager
//
//  Created by William Gustafson on 1/6/20.
//
// Credit for the implementation goes mostly to Phil Dennis-Jordan (https://philjordan.eu)
// who provided critical guidance and code examples via:
// https://stackoverflow.com/questions/59594123/enabling-closed-display-mode-w-o-meeting-apples-requirements

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
}

- (IBAction) enableAction: (id) sender
{
    [self enableCDM:YES];
}

- (IBAction) disableAction: (id) sender
{
    [self enableCDM:NO];
}

- (void) enableCDM: (BOOL) enable
{
    io_connect_t connection = IO_OBJECT_NULL;
    io_service_t pmRootDomain = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPMrootDomain"));
    
    IOServiceOpen (pmRootDomain, current_task(), 0, &connection);
    RootDomain_SetDisableClamShellSleep(connection, enable);
    IOServiceClose(connection);
}

IOReturn RootDomain_SetDisableClamShellSleep (io_connect_t root_domain_connection, bool disable)
{
    uint32_t num_outputs = 0;
    uint32_t input_count = 1;
    uint64_t input[input_count];
    input[0] = (uint64_t) { disable ? 1 : 0 };

    return IOConnectCallScalarMethod(root_domain_connection, kPMSetClamshellSleepState, input, input_count, NULL, &num_outputs);
}

- (void) applicationWillTerminate: (NSNotification *) aNotification
{
    // revert to normal system behavior on quit
    [self enableCDM:NO];
}

@end
