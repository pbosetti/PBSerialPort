PBSerialPort
============

A quick and dirty serialport class written in Objective-C and tuned to be used as MacRuby class.

Usage
-----

In MacRuby:
    
    require "PBSerialPort"
    sp = PBSerialPort.new("/dev/tty.usbserial-212fr5")