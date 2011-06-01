
require 'Qt'
require 'slackware'
require 'slackware/gui/system_package_widget'

module Slackware::Gui
	# http://doc.qt.nokia.com/latest/qwidget.html
	class InstalledPackagesTab < Qt::Widget
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
			@pkgs = Slackware::System.installed_packages

			# This Should fix the resizing ugliness
			len = 225
			@packageListWidget.setMinimumWidth(len)
			@packageListWidget.setMaximumWidth(len + 30)

			@pkgs.each {|pkg|
				# each package here,has a mouse event/SIGNAL
				# to show it's info in right panel
				# http://doc.qt.nokia.com/latest/qlistwidgetitem.html
				packageListWidgetItem = Qt::ListWidgetItem.new(pkg.name)
				# hover over info, of the full package name
				packageListWidgetItem.setToolTip(pkg.fullname)
				@packageListWidget.addItem(packageListWidgetItem)
			}

			# TODO setup a connect() for when the tab is clicked
			# to render the statusBar
			# http://doc.qt.nokia.com/latest/qstatusbar.html
			parent.statusBar.clearMessage
			parent.statusBar.showMessage(
				"%d packages installed; %d tags used: %s" % [
					@pkgs.count,
					Slackware::System.tags_used.count,
					Slackware::System.tags_used.map {|tag|
					"%s::%d" % [tag[:tag].empty? ? "\"\"" : tag[:tag], tag[:count]]
				}.join("  ")]
			)

			@frameLayout.addWidget(@packageListWidget)
			@frameLayout.addWidget(@packageInfoWidget)
			#self.methods.each {|m| p m if m =~ /lay/i }

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
