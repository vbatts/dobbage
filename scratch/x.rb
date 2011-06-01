=begin
** Form generated from reading ui file 'dobbage_window_view.ui'
**
** Created: Sat Apr 9 15:37:07 2011
**      by: Qt User Interface Compiler version 4.7.0
**
** WARNING! All changes made in this file will be lost when recompiling ui file!
=end

class Ui_MainWindow
    attr_reader :centralwidget
    attr_reader :tabWidget
    attr_reader :tab
    attr_reader :gridLayoutWidget
    attr_reader :gridLayout
    attr_reader :listView
    attr_reader :listView_2
    attr_reader :listWidget
    attr_reader :tab_2
    attr_reader :menubar
    attr_reader :statusbar

    def setupUi(mainWindow)
    if mainWindow.objectName.nil?
        mainWindow.objectName = "mainWindow"
    end
    mainWindow.resize(800, 600)
    @centralwidget = Qt::Widget.new(mainWindow)
    @centralwidget.objectName = "centralwidget"
    @tabWidget = Qt::TabWidget.new(@centralwidget)
    @tabWidget.objectName = "tabWidget"
    @tabWidget.geometry = Qt::Rect.new(0, 0, 811, 571)
    @tab = Qt::Widget.new()
    @tab.objectName = "tab"
    @gridLayoutWidget = Qt::Widget.new(@tab)
    @gridLayoutWidget.objectName = "gridLayoutWidget"
    @gridLayoutWidget.geometry = Qt::Rect.new(-1, -1, 791, 531)
    @gridLayout = Qt::GridLayout.new(@gridLayoutWidget)
    @gridLayout.objectName = "gridLayout"
    @gridLayout.setContentsMargins(0, 0, 0, 0)
    @listView = Qt::ListView.new(@gridLayoutWidget)
    @listView.objectName = "listView"
    @sizePolicy = Qt::SizePolicy.new(Qt::SizePolicy::MinimumExpanding, Qt::SizePolicy::Expanding)
    @sizePolicy.setHorizontalStretch(0)
    @sizePolicy.setVerticalStretch(0)
    @sizePolicy.heightForWidth = @listView.sizePolicy.hasHeightForWidth
    @listView.sizePolicy = @sizePolicy
    @listView.maximumSize = Qt::Size.new(400, 16777215)
    @listView.sizeIncrement = Qt::Size.new(20, 0)
    @listView.baseSize = Qt::Size.new(100, 0)

    @gridLayout.addWidget(@listView, 0, 0, 2, 1)

    @listView_2 = Qt::ListView.new(@gridLayoutWidget)
    @listView_2.objectName = "listView_2"

    @gridLayout.addWidget(@listView_2, 1, 1, 1, 1)

    @listWidget = Qt::ListWidget.new(@gridLayoutWidget)
    @listWidget.objectName = "listWidget"

    @gridLayout.addWidget(@listWidget, 0, 1, 1, 1)

    @tabWidget.addTab(@tab, Qt::Application.translate("MainWindow", "Tab 1", nil, Qt::Application::UnicodeUTF8))
    @tab_2 = Qt::Widget.new()
    @tab_2.objectName = "tab_2"
    @tabWidget.addTab(@tab_2, Qt::Application.translate("MainWindow", "Tab 2", nil, Qt::Application::UnicodeUTF8))
    mainWindow.centralWidget = @centralwidget
    @menubar = Qt::MenuBar.new(mainWindow)
    @menubar.objectName = "menubar"
    @menubar.geometry = Qt::Rect.new(0, 0, 800, 21)
    mainWindow.setMenuBar(@menubar)
    @statusbar = Qt::StatusBar.new(mainWindow)
    @statusbar.objectName = "statusbar"
    mainWindow.statusBar = @statusbar

    retranslateUi(mainWindow)

    Qt::MetaObject.connectSlotsByName(mainWindow)
    end # setupUi

    def setup_ui(mainWindow)
        setupUi(mainWindow)
    end

    def retranslateUi(mainWindow)
    mainWindow.windowTitle = Qt::Application.translate("MainWindow", "MainWindow", nil, Qt::Application::UnicodeUTF8)
    @tabWidget.setTabText(@tabWidget.indexOf(@tab), Qt::Application.translate("MainWindow", "Tab 1", nil, Qt::Application::UnicodeUTF8))
    @tabWidget.setTabText(@tabWidget.indexOf(@tab_2), Qt::Application.translate("MainWindow", "Tab 2", nil, Qt::Application::UnicodeUTF8))
    end # retranslateUi

    def retranslate_ui(mainWindow)
        retranslateUi(mainWindow)
    end

end

module Ui
    class MainWindow < Ui_MainWindow
    end
end  # module Ui

