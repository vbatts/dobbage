# Widget for displaying the package data.
# If you want mouse events for interacting with the image, they can be put in this class.

# http://doc.qt.nokia.com/latest/qwidget.html
# http://doc.qt.nokia.com/latest/qtreewidget.html
class PackageWidget < Qt::Widget

  # Initialize the widget.
  def initialize(parent=nil)
    @parent = parent
    super(parent)
    setMinimumSize(512, 512)
    # http://doc.qt.nokia.com/latest/qpixmap.html
    #@pixmap = Qt::Pixmap.new
  end

  # XXX do some hot stuff
  def load_info
    
  end
end
