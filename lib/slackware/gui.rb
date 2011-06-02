# 2010, 2011 Vincent Batts, vbatts@hashbangbash.com
#
# Main file of Slackware package viewer.
#
# A good reference, is the qtsamuri example_02.rb

# Load our QtRuby main window class:
require 'slackware/gui/dobbage_window'
require 'optparse'

module Slackware::Gui
	class Args
		def self.parse(*args)
			options = {}

			opts = OptionParser.new(args) {|opts|
				opts.banner = "Usage: dobbage [options]"
				opts.separator("")
				opts.separator("Optional Flags:")

				opts.on_tail("-v","--version","show version information") {|o|
					puts <<-EOF
Slackware Linux Version: #{SLACKWARE_VERSION}
slack-utils version: #{UTILS_VERSION}
dobbage version: #{DOBBAGE_VERSION}
EOF
					exit
				}
				opts.on_tail("-h","--help","show this help message") {|o|
					puts opts
					exit
				}
			}

			opts.parse!
			
			return options
		end
	end

	# Launch the application:
	def self::launch(*args)
	  args.flatten!.compact!
	  options = Slackware::Gui::Args.parse(args)

	  app = Qt::Application.new(args)
	  window = DobbageWindow.new(args)
	  window.show
	  app.exec
	end
end

