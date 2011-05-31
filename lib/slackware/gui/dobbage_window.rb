
require 'Qt'
require 'slackware/gui/installed_packages_tab'
require 'slackware/gui/removed_packages_tab'

module Slackware
	module Gui
		# http://doc.qt.nokia.com/latest/qmainwindow.html
		class DobbageWindow < Qt::MainWindow
			slots 'about()'
		 
			def initialize(args, parent = nil)
				super(parent)
		
			 	setup_icon()
			 	setup_menus()
			 	setup_tabs()
                                setup_drop_events()
		
				self.statusBar()
		
				self.windowTitle = tr("Dobbage")
			end
		
			def about 
				about_info = <<-EOF

Dobbage lifts Slackware's skirt

Slackware Linux Version: #{SLACKWARE_VERSION}
slack-utils version: #{UTILS_VERSION}

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
		
				aboutView = helpMenu.addAction(tr("&About"))
				connect(exitAction, SIGNAL("triggered()"), $qApp, SLOT("quit()"))
				connect(aboutView, SIGNAL("triggered()"), self, SLOT("about()"))
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
                        end
		end
	end 
end
