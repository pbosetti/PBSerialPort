#import "SPController.h"
#define defaults [NSUserDefaults standardUserDefaults]

@implementation SPController

@synthesize standardBaudRates, availablePorts;
@synthesize baudRateIndex;

- (id)init {
	NSLog(@"initing controller");
	self = [super init];
	lastLine = [NSMutableString stringWithString: @""];
	lockInput = FALSE;
	[console setString:@""];
	standardBaudRates = [NSArray arrayWithObjects:
						 [NSNumber numberWithInt:1200],
						 [NSNumber numberWithInt:1800],
						 [NSNumber numberWithInt:2400],
						 [NSNumber numberWithInt:4800],
						 [NSNumber numberWithInt:7200],
						 [NSNumber numberWithInt:9600],
						 [NSNumber numberWithInt:14400],
						 [NSNumber numberWithInt:28800],
						 [NSNumber numberWithInt:38400],
						 [NSNumber numberWithInt:57600],
						 [NSNumber numberWithInt:76800],
						 [NSNumber numberWithInt:115200],
						 nil];
	self.baudRateIndex = [defaults integerForKey:@"baudRateIndex"];
	[self reloadPorts:self];
	return self;
}

- (IBAction)reloadPorts:(id)sender {
	NSString *portRoot = @"/dev";
	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:portRoot error:NULL];
	self.availablePorts = [dirContents filteredArrayUsingPredicate:
								[NSPredicate predicateWithFormat:@"SELF BEGINSWITH 'tty.'"]];
	NSLog(@"Available ports: %@)", availablePorts);
}

- (void)readerLoop {
	NSAutoreleasePool *threadPool = [[NSAutoreleasePool alloc] init];
	reader = [NSThread currentThread];
	NSLog(@"Starting reader thread");
	NSString *line = @"";
	while (serialPort.isOpen) {
		if ([serialPort availableBytes] > 0) {
			line = [serialPort readLine];
			lockInput = TRUE;
			[console insertText:line];
			[console insertText:@"\n"];
			lockInput = FALSE;
		}
		usleep(5000);
	}
	NSLog(@"Closing reader thread");
	[threadPool release];
}

- (IBAction)test:(id)sender {
	NSLog(@"Action by %@", sender);
	[self performSelectorInBackground:@selector(readerLoop) withObject:self];
}

- (IBAction)read:(id)sender {
	lockInput = TRUE;
	[console insertText:[serialPort readLine]];
	[console insertText:@"\n"];
	lockInput = FALSE;
}

- (IBAction)openOrClose:(id)sender {
	switch ([sender selectedSegment]) {
		case 0:
			[serialPort setPort:[@"/dev/" stringByAppendingString:[availablePorts objectAtIndex:portIndex]]];
			[serialPort setBaud:[[standardBaudRates objectAtIndex:baudRateIndex] intValue]];
			if ([serialPort open])
				[self performSelectorInBackground:@selector(readerLoop) withObject:self];
			else
				[sender setSelectedSegment:1];
			break;
		case 1:
			[serialPort close];
			break;
		default:
			break;
	}
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return TRUE;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[defaults setInteger:portIndex forKey:@"portIndex"];
	[defaults setInteger:baudRateIndex forKey:@"baudRateIndex"];
	[serialPort close];
}

- (void)textDidChange:(NSNotification *)aNotification {
	if (!lockInput) {
		id sender = [aNotification object];
		NSString *text = [sender string];
		if ([text characterAtIndex:[text length]-1] == '\n') {
			NSArray *lines = [text componentsSeparatedByString:@"\n"];
			[serialPort writeString:[lines objectAtIndex:[lines count]-2]];
		}
	}
}
@end
