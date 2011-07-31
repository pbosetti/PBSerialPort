PBSerialPort
============

A quick and dirty serialport class written in Objective-C and tuned to be used as MacRuby class.

Usage
-----

Copy the build product PBSerialPort.bundle to your MacRuby project folder.

Using the example Arduino sketch provided in AnalogSerialRead, run the following code in MacRuby:
    
    #!/usr/env macruby

    require "./PBSerialPort.bundle"

    sp = PBSerialPort.new
    sp.port = "/dev/tty.usbmodem411"
    sp.baud = 9600

    running = true

    # Install management of ctrl-C signal
    Signal.trap("SIGINT") do
      running = false
    end

    sp.open
    raise unless sp.isOpen
    sleep 2 # Give Arduino time for booting

    values = []
    while running do
      (0..5).each do |pin|
        sp.writeChar pin.to_s
        values << sp.readLine.chomp
      end
      puts values * " "
      values.clear
      sleep 0.1
    end

    print "Closing serial port..."
    sp.close
    puts "done!"