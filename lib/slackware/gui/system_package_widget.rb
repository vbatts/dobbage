
require 'Qt'
require 'slackware/gui/packageinfowidget'

module Slackware
	module Gui
		# http://doc.qt.nokia.com/latest/qwidget.html
		class SystemPackageWidget < Qt::Widget
			slots 'open_package_file()'

			def initialize(package = nil, parent = nil)
				super(parent)
				setMinimumSize(512, 512)

				# http://doc.qt.nokia.com/latest/qframe.html
				frame = Qt::Frame.new
				# http://doc.qt.nokia.com/latest/qvboxlayout.html
				frameLayout = Qt::VBoxLayout.new(frame)

				# http://doc.qt.nokia.com/latest/qlistwidget.html
				@infoWidget = Slackware::Gui::PackageInfoWidget.new(self)
				@fileListWidget = Qt::ListWidget.new(self)
				unless package.nil?
					show(package)
				end

				frameLayout.addWidget(@infoWidget)
				frameLayout.addWidget(@fileListWidget)
		
				self.layout = frameLayout

				self.connect(@fileListWidget, SIGNAL('itemPressed(QListWidgetItem *)'),
					     self, SIGNAL('open_package_file()'))
			end

			def show(package)
				# clear previous infoz
				@infoWidget.clear()

				# http://doc.qt.nokia.com/latest/qlabel.html
				text = ""

				text += "<b>Package Name: </b>"
				text += package.fullname
				text += "<br/>"

				text += "<b>Compressed Package Size: </b>"
				text += package.compressed_size
				text += "<br/>"

				text += "<b>Uncompressed Package Size: </b>"
				text += package.uncompressed_size
				text += "<br/>"

				text += "<b>Modification Time: </b>"
				text += package.get_time.to_s
				text += "<br/>"

				text += "<b>Package Description: </b>"
				text += "<pre>"
				package.package_description.each {|line|
					text += line
					text += "<br/>"
				}
				text += "</pre>"

				@infoWidget.setText(tr(text))

				# clear previous files
				@fileListWidget.clear()
				package.get_owned_files.each {|file|
					fileListWidgetItem = Qt::ListWidgetItem.new(file)
					# hover over info, of the full package name
					#fileListWidgetItem.setToolTip(pkg.fullname)
					@fileListWidget.addItem(fileListWidgetItem)
				}
			end

			def open_package_file()
				file = File.join("/", @fileListWidget.currentItem().text)
				if File.exist?(file) and File.readable?(file)
					system("xdg-open #{file}")
				end
			end
		end
	end
end
