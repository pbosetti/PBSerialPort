# test.rb
# Serialport
#
# Created by Paolo Bosetti on 11/2/09.
# Copyright 2009 Dipartimento di Ingegneria Meccanica e Strutturale. All rights reserved.


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