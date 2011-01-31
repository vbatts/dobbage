
require 'Qt'

module Slackware
	module Gui
		# http://doc.qt.nokia.com/latest/qwidget.html
		class SystemPackageWidget < Qt::Widget
			def initialize(package = nil, parent = nil)
				super(parent)
				setMinimumSize(512, 512)

				# http://doc.qt.nokia.com/latest/qframe.html
				frame = Qt::Frame.new
				# http://doc.qt.nokia.com/latest/qvboxlayout.html
				frameLayout = Qt::VBoxLayout.new(frame)

				# http://doc.qt.nokia.com/latest/qlistwidget.html
				@infoWidget = Qt::ListWidget.new(self)
				@fileListWidget = Qt::ListWidget.new(self)
				unless package.nil?
					show(package)
				end

				frameLayout.addWidget(@infoWidget)
				frameLayout.addWidget(@fileListWidget)
		
				self.layout = frameLayout
			end

			def show(package)
				# clear previous infoz
				@infoWidget.clear()
				# http://doc.qt.nokia.com/latest/qlistwidgetitem.html
				@infoWidget.addItem(Qt::ListWidgetItem.new(package.fullname + "\n"))
				if self.parent.class == RemovedPackagesTab
					@infoWidget.addItem(Qt::ListWidgetItem.new("Remove Time: #{package.get_time}\n"))
				elsif self.parent.class == InstalledPackagesTab
					@infoWidget.addItem(Qt::ListWidgetItem.new("Install Time: #{package.get_time}\n"))
				else
					@infoWidget.addItem(Qt::ListWidgetItem.new("Time: #{package.get_time}\n"))
				end
				package.package_description.each {|line|
					@infoWidget.addItem(Qt::ListWidgetItem.new(line))
				}

				# clear previous files
				@fileListWidget.clear()
				package.get_owned_files.each {|file|
					fileListWidgetItem = Qt::ListWidgetItem.new(file)
					# hover over info, of the full package name
					#fileListWidgetItem.setToolTip(pkg.fullname)
					@fileListWidget.addItem(fileListWidgetItem)
				}
			end
		end
	end
end
