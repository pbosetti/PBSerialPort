#import <Cocoa/Cocoa.h>
#import "PBSerialPort.h"

@interface SPController : NSObject
{
    IBOutlet id runTest;
	IBOutlet PBSerialPort *serialPort;
	IBOutlet NSTextView *console;
	NSMutableString *lastLine;
	BOOL lockInput;
	NSThread *reader;
	NSArray *standardBaudRates, *availablePorts;
	NSInteger baudRateIndex, portIndex;
}

@property (readonly) NSArray *standardBaudRates;
@property (retain) NSArray *availablePorts;
@property (assign) NSInteger baudRateIndex;

- (IBAction)test:(id)sender;
- (IBAction)read:(id)sender;
- (IBAction)openOrClose:(id)sender;
- (IBAction)reloadPorts:(id)sender;
- (void)readerLoop;
@end
