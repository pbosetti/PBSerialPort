//
//  PBSerialPort.m
//  Serialport
//
//  Created by Paolo Bosetti on 8/23/09.
//  Copyright 2009 Dipartimento di Ingegneria Meccanica e Strutturale. All rights reserved.
//

#import "PBSerialPort.h"

// Added for MacRuby
void Init_PBSerialPort(void) { }

@implementation PBSerialPort
@synthesize port;
@synthesize baud, bufferSize;
@synthesize status;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keys = [[NSSet alloc] init];
	if ([key isEqualToString:@"isOpen"]) {
		keys = [NSSet setWithObject:@"status"];
	}
	return keys;
}

- (id)init {
	self = [super init];
	self.baud = DEFAULT_BAUD;
	self.bufferSize = DEFAULT_BUFFER_SIZE;
	self.status = PORT_CLOSED;
	return self;
}

- (BOOL) isOpen {
	return self.status == PORT_OPEN ? TRUE : FALSE;
}

- (BOOL) open {
	struct termios options;
	//NSLog(@"Port: %@, baud: %d",port,baud);
	/* open the USB Serial Port */
	fd = open([port UTF8String], O_RDWR | O_NOCTTY | O_NONBLOCK );
	if (fd == -1) {
		return FALSE;
	}
	else 
		fcntl(fd, F_SETFL, 0);
	
	/* set the port to 9600 Baud, 8 data bits, etc. */
	tcgetattr(fd, &options);
	cfsetispeed(&options, baud);
	cfsetospeed(&options, baud);
	options.c_cflag |= (CLOCAL | CREAD);
	options.c_cflag &= ~CSIZE; /* Mask the character size bits */
	options.c_cflag |= CS8;    /* Select 8 data bits */
	options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
	tcsetattr(fd, TCSANOW, &options);
	self.status = PORT_OPEN;
	return TRUE;
}

- (BOOL) close {
	if (status == PORT_OPEN) {
		if (close(fd) == 0) {
			self.status = PORT_CLOSED;
			return TRUE;
		}
		else {
			return FALSE;
		}
	}
	else {
		return FALSE;
	}
}

- (NSString *) readLine {
	char *bufptr;
	char buffer[bufferSize];
	bzero(buffer, bufferSize);
	int nbytes;
	char inchar;
	
	bufptr = buffer;
	while ((nbytes = read(fd, &inchar, 1)) > 0)
	{
		if (inchar == '\r') continue;
		if (inchar == '\n') break;
		*bufptr = inchar;
		++bufptr;
	}
	*bufptr = '\0';
	return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (unsigned int)availableBytes {
	unsigned int availableBytes;
	if (ioctl(fd, FIONREAD, &availableBytes) == -1)
    NSLog(@"Error: %d", errno);
	return availableBytes;
}

- (char) readChar {
	char result = '\0';
  read(fd, &result, 1);
	return result;
}
	
- (BOOL) writeString: (NSString *)aString {
	const char *buffer = [aString UTF8String];
	write(fd, buffer, [aString length]);
	return TRUE;
}

- (BOOL) writeChar: (char)aChar {
	write(fd, &aChar, 1);
	return TRUE;
}


@end
