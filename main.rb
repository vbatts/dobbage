
require 'window'

if $0 == __FILE__
  Gtk.init
  win = DobbsWindow.new(ARGV[0]).set_default_size(400, 400).show_all
  Gtk.main
end