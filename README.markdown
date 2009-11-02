PBSerialPort
============

A quick and dirty serialport class written in Objective-C and tuned to be used as MacRuby class.

Usage
-----

In MacRuby:
    
    require "build/Release/PBSerialPort"

    sp = PBSerialPort.new
    sp.port = "/dev/tty.usbserial-A6004aLr"
    sp.baud = 115200

    sp.open
    raise unless sp.isOpen
    sleep 2
    sp.writeChar '?'

    first = true
    while sp.availableBytes > 0 or first do
      print sp.readChar.chr
      first = false
    end

    sp.close