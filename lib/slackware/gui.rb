#!/usr/bin/env ruby
# 2010, 2011 Vincent Batts, vbatts@hashbangbash.com
#
# Main file of Slackware package viewer.
#

# Load necessary libraries:
require 'rubygems'
require 'Qt'
# Load our QtRuby main window class:
require 'slackware/gui/dobbage_window'

# Another good example, is the qtsamuri example_02.rb

module Slackware
	module Gui
		# Launch the application:
		def self::launch(*args)
		  args.flatten!.compact!
		  app = Qt::Application.new(args)
		  window = DobbageWindow.new(args)
		  window.show
		  app.exec
		end
	end
end

