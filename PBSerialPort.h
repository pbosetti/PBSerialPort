//
//  PBSerialPort.h
//  Serialport
//
//  Created by Paolo Bosetti on 8/23/09.
//  Copyright 2009 Dipartimento di Ingegneria Meccanica e Strutturale. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <string.h>  /* String function definitions */
#import <unistd.h>  /* UNIX standard function definitions */
#import <fcntl.h>   /* File control definitions */
#import <errno.h>   /* Error number definitions */
#import <termios.h> /* POSIX terminal control definitions */
#import <sys/ioctl.h>

#define DEFAULT_BAUD        9600
#define DEFAULT_BUFFER_SIZE 256
#define PORT_OPEN  0
#define PORT_CLOSED 1

@interface PBSerialPort : NSObject {
	NSString * port;
	NSInteger baud;
	NSInteger bufferSize;
	NSInteger status;
	@private
	int fd;
}

@property (copy) NSString * port;
@property (assign) NSInteger baud;
@property (assign) NSInteger bufferSize;
@property (assign) NSInteger status;
@property (readonly) BOOL isOpen;

- (BOOL) isOpen;
- (BOOL) open;
- (BOOL) close;
- (NSInteger)availableBytes;
- (NSString *) readLine;
- (char) readChar;
- (BOOL) writeString: (NSString *)aString;
- (BOOL) writeChar: (char)aChar;
@end
