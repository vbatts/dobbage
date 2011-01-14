#!/usr/bin/env ruby
# 2010, 2011 Vincent Batts, vbatts@hashbangbash.com
#
# Main file of Slackware package viewer.
# Execute this file to start the program.
#
#$: <<  File.absolute_path(File.dirname(__FILE__) + "/../lib")

# Load necessary libraries:
require 'rubygems'
require 'Qt4'
#require 'RMagick'
#require 'dicom'

# Load our QtRuby main window class:
require 'slackware/gui/main_window'

# Launch the application:
def slackware_gui(*args)
  args.flatten!.compact!
  app = Qt::Application.new(args)
  win = MainWindow.new
  win.show
  app.exec
end

