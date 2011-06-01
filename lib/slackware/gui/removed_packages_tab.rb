
require 'Qt'
require 'slackware/gui/system_package_widget'
include Slackware

module Slackware
	module Gui
		# http://doc.qt.nokia.com/latest/qwidget.html
		class RemovedPackagesTab < Qt::Widget
			slots 'show_package_info()'
		
			def initialize(parent=nil)
				super(parent)
				setMinimumSize(512, 512)
		
				# http://doc.qt.nokia.com/latest/qframe.html
				frame = Qt::Frame.new
				# http://doc.qt.nokia.com/latest/qhboxlayout.html
				@frameLayout = Qt::HBoxLayout.new(frame)
		
				# http://doc.qt.nokia.com/latest/qlistwidget.html
				@packageListWidget = Qt::ListWidget.new(self)
				# TODO It may be nice to have a Welcome screen here,
				# that will get clobbered on first package click
				@packageInfoWidget = Slackware::Gui::SystemPackageWidget.new(nil, self)
		
				# Build the left side list of packages
				@pkgs = Slackware::System.removed_packages

				# This Should fix the resizing ugliness
				len = 250
				@packageListWidget.setMinimumWidth(len)
				@packageListWidget.setMaximumWidth(len + 50)

				@pkgs.each {|pkg|
					# each package here,has a mouse event/SIGNAL
					# to show it's info in right panel
					# http://doc.qt.nokia.com/latest/qlistwidgetitem.html

					text = pkg.name
					if a = pkg.upgrade_time
						text += " (#{pkg.upgrade_time})"
					end
					packageListWidgetItem = Qt::ListWidgetItem.new(tr(text))


					# hover over info, of the full package name
					packageListWidgetItem.setToolTip(pkg.fullname)

					@packageListWidget.addItem(packageListWidgetItem)
				}
		
				# TODO setup a connect() for when the tab is clicked
				# to render the statusBar
				#parent.statusBar.clearMessage
				#parent.statusBar.showMessage("%d packages removed" % [@pkgs.count])
		
				@frameLayout.addWidget(@packageListWidget)
				@frameLayout.addWidget(@packageInfoWidget)
				
				# this attachs the click event to a method that can work with it
				self.connect(@packageListWidget, SIGNAL('itemPressed(QListWidgetItem *)'),
					     self, SIGNAL('show_package_info()'))
		
				self.layout = @frameLayout
			end
		
			def show_package_info()
				index = @packageListWidget.indexFromItem(@packageListWidget.currentItem())
				@packageInfoWidget.show(@pkgs[index.row])
			end
		end
	end
end
