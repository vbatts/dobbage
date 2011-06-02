
require 'Qt'
require 'slackware/gui/installed_packages_tab'
require 'slackware/gui/constants'
require 'slackware/gui/removed_packages_tab'

module Slackware::Gui
	# http://doc.qt.nokia.com/latest/qmainwindow.html
	class DobbageWindow < Qt::MainWindow
		slots 'show_about()', 'show_bug_report()', 'show_info_box()'
	 
		def initialize(args, parent = nil)
			super(parent)
	
		 	setup_icon()
		 	setup_menus()
		 	setup_tabs()
                               setup_drop_events()
	
			self.statusBar()
	
			self.windowTitle = tr("Dobbage")
		end

		def show_bug_report()
			cmd = "xdg-open #{DOBBAGE_URL}/issues"
			STDERR.write("INFO: executing #{cmd.inspect}\n")
			system(cmd)
		end

		def show_info_box()
			r_file = "/usr/doc/dobbage-#{DOBBAGE_VERSION}/README"

			if File.exist?(r_file)
				cmd = "xdg-open #{r_file}"
				STDERR.write("INFO: executing #{cmd.inspect}\n")
				system(cmd)
			else
				b = Qt::MessageBox.new()
				b.setText(tr("#{r_file.inspect} is not present."))
				b.setInformativeText(tr("You should visit\n#{DOBBAGE_URL}\nfor more information"))
				b.exec()
			end

		end

		def show_about 
			about_info = <<-EOF
<h2>Dobbage lifts Slackware's skirt</h2>
<br/>
<b>Slackware Linux Version</b>: #{SLACKWARE_VERSION}<br/>
<b>slack-utils version</b>: #{UTILS_VERSION}<br/>
<b>dobbage version</b>: #{DOBBAGE_VERSION}<br/>
<br/>
<b>Website</b>: <a href="#{DOBBAGE_URL}">#{DOBBAGE_URL}</a><br/>
<b>Author</b>: #{DOBBAGE_AUTHOR}<br/>
<br/>
EOF
			# http://doc.qt.nokia.com/latest/qmessagebox.html
			Qt::MessageBox.about(self, tr("About"), about_info)
		end
	
		def setup_icon
			@logo_icon = Qt::Icon.new("/usr/share/pixmaps/slackware.xpm")
			self.windowIcon = @logo_icon
		end
	
		def setup_menus
			fileMenu = menuBar().addMenu(tr("&File"))
			helpMenu = menuBar().addMenu(tr("&Help"))
	
			exitAction = fileMenu.addAction(tr("&Exit"))
			# http://doc.qt.nokia.com/latest/qkeysequence.html
			exitAction.shortcut = Qt::KeySequence.new(tr("Ctrl+Q"))
	
			infoView = helpMenu.addAction(tr("&Info"))
			bugView = helpMenu.addAction(tr("Report &Bug"))
			helpMenu.addSeparator()
			aboutView = helpMenu.addAction(tr("&About"))

			connect(exitAction, SIGNAL("triggered()"), $qApp, SLOT("quit()"))
			connect(aboutView, SIGNAL("triggered()"), self, SLOT("show_about()"))
			connect(infoView, SIGNAL("triggered()"), self, SLOT("show_info_box()"))
			connect(bugView, SIGNAL("triggered()"), self, SLOT("show_bug_report()"))
		end

		def setup_tabs
			# http://doc.qt.nokia.com/latest/qtabwidget.html
		 	@tabWidget = Qt::TabWidget.new
			@tabWidget.addTab(Slackware::Gui::InstalledPackagesTab.new(self), tr("Installed"))
			@tabWidget.addTab(Slackware::Gui::RemovedPackagesTab.new(self), tr("Removed"))
			self.centralWidget = @tabWidget
		end

                def setup_drop_events
                        setAcceptDrops(true)
                end
		

                # These are mandatory overrides, required in Qt's d&d
                # implementation.
                # http://doc.qt.nokia.com/4.7/dnd.html
                def dragEnterEvent(event)
                        if event.mimeData.hasFormat("text/plain") and event.mimeData.text() =~ /(tgz|txz|tbz)$/
                                event.accept
                        end
                end
                def dropEvent(event)
                        # XXX do some hot stuff here
                        # like opening a new tab for the package archive, like
                        # showing it's info and files
                end
        end
end 
