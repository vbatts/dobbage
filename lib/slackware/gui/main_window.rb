# Main window of the application (defining GUI layout and actions).
# vim : set ts=2 sw=2 :

require 'slackware'
require 'slackware/gui/tree_model'
require 'slackware/gui/package_widget'

RE_SLACKWARE_PACKAGE = Regexp.new(/\.t[bxg]z$/)

class PackageError < StandardError ; end

# http://doc.qt.nokia.com/latest/qmainwindow.html
class MainWindow < Qt::MainWindow

  slots 'view_file()', 'about()'
  attr_reader :view

  def initialize(parent=nil)
    super(parent)
    setupMenus
    setupWidgets
    @logo_icon = Qt::Icon.new(":/images/icons/slackware-logo.svg"), tr("logo")
    # http://doc.qt.nokia.com/latest/qsizepolicy.html
    setSizePolicy(Qt::SizePolicy.new(Qt::SizePolicy::Fixed, Qt::SizePolicy::Fixed))
    setWindowTitle(tr("Slackware Package Viewer"))
  end

  # Displays an information text box:
  def about
    # http://doc.qt.nokia.com/latest/qmessagebox.html
    Qt::MessageBox.about(self, tr("About"), tr("Slackware Packge Viewer\n made with QtRuby."))
  end

  # Reads a package file, and will display information about the package,
  # as well as list it in the tree view to side. Maybe a section named "Files"
  # These pacakge infos, should be cached, since they may open more than one.
  def load_package(file)
    unless file =~ RE_SLACKWARE_PACKAGE
        raise PackageError.new("#{file} is not a slackware package\n")
    end
    obj = Slackware::Package.parse(file)
    # TODO this should parse the name of the file,
    # read the file list, and the install/slack-desc
    unless obj.name.nil?
      # FIXME this is a stub
      # Load load package information
      @info = obj.get_info
      unless @view # Load an empty image object.
	p = Slackware::Package.new
        @info = p.get_info
      end
      # Add information from the DICOM object to the the tree model and update widgets:
      model = TreeModel.new(obj)
      @treeView.model = model
      # XXX
      @packageWidget.load_info
    else # Failed:
      Qt::MessageBox.warning(self, tr("Open file"), tr("Error: Selected file is not recognized as a Slackware package."))
    end
  end

  # Launching open file dialogue.
  def view_file
    fileName = Qt::FileDialog.getOpenFileName(self, tr("View file"), "", "Slackware packages (*.t[gxb]z)")
    begin
      load_package(fileName) unless fileName.nil?
    rescue PackageError => ex
      Qt::MessageBox.warning(self, tr("Open file"), tr("Error: Selected file is not recognized as a Slackware package."))
    rescue
      Qt::MessageBox.warning(self, tr("Open file"), tr("ERROR: Other"))
    end
  end

  # Setting up menu items.
  def setupMenus
    # Menus:
    fileMenu = menuBar().addMenu(tr("&File"))
    helpMenu = menuBar().addMenu(tr("&Help"))
    # Menu items:
    openFile = fileMenu.addAction(tr("&View File..."))
    openFile.shortcut = Qt::KeySequence.new(tr("Ctrl+O"))
    exitAction = fileMenu.addAction(tr("E&xit"))
    exitAction.shortcut = Qt::KeySequence.new(tr("Ctrl+Q"))
    aboutView = helpMenu.addAction(tr("&About"))
    aboutView.shortcut = Qt::KeySequence.new(tr("Ctrl+A"))
    # Menu item actions:
    connect(openFile, SIGNAL('triggered()'), self, SLOT('view_file()'))
    connect(exitAction, SIGNAL('triggered()'), $qApp, SLOT('quit()'))
    connect(aboutView, SIGNAL('triggered()'), self, SLOT('about()'))
  end

  # Setting up the widgets in the main window.
  # XXX This should list "Installed" and "Removed" on the left
  #
  def setupWidgets
    # Create a frame which in which widgets will be ordered horisontally:
    # http://doc.qt.nokia.com/latest/qframe.html
    # http://doc.qt.nokia.com/latest/qtextframe.html
    frame = Qt::Frame.new
    # http://doc.qt.nokia.com/latest/qhboxlayout.html
    frameLayout = Qt::HBoxLayout.new(frame)
    # XXX need a PackageWidget layout here
    @packageWidget = PackageWidget.new(self)
    # http://doc.qt.nokia.com/latest/qtreeview.html
    @treeView = Qt::TreeView.new
    @treeView.itemsExpandable = true
    p @treeView
    p @treeView.methods
    # Add the two widgets (tree view and image) to the frame:
    frameLayout.addWidget(@treeView)
    frameLayout.addWidget(@packageWidget)
    setCentralWidget(frame)
  end

end