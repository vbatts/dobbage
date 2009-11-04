# kicking around the idea of a simple GUI for displaying
# packages, upgrade history, package contents, etc 

require 'gtk2'
require 'fileutils'
include Gtk

Logo="images/icons/logo.jpg"

module Utils
  module_function
  def show_error_dialog(window, text)
    dialog = Gtk::MessageDialog.new(window, Gtk::Dialog::MODAL, 
                                    Gtk::MessageDialog::ERROR, 
                                    Gtk::MessageDialog::BUTTONS_CLOSE, text)
    dialog.run
    dialog.destroy
  end
end

class DobbsWindow < Gtk::Window

  def initialize
    super
    
    modify_bg(STATE_NORMAL,Stock_color)
    #signal_connect("key-press-event") { |widget,event|
    # destroy if event.keyval==ESC
    #}
    set_icon(Gdk::Pixbuf.new(Logo))
  end
end


class Help

  def initialize
    w=FAIRwindow.new
    w.set_title( "Help" )
    w.set_border_width(10)
    
    @notebook=Notebook.new
    create_pages
    
    w.add(@notebook).show_all
    
    @notebook.signal_connect("switch_page") { |widget,page,num_page|
      page_switch(widget,page,num_page)
    }
    @notebook.next_page #nur nötig, damit "Offen"-Bild
    @notebook.prev_page #bereits am Anfang angezeigt wird
  end
  
  def create_pages
    help_text=[]
    help_text[1]="Introduction"
    help_text[2]="The Details"
    help_text[3]="Strategy"
    
    1.upto(help_text.length - 1) { | i |
    buffer="  #{help_text[i]}"
    
    view=TextView.new
    view.editable=false
    view.cursor_visible=false
    
    if File.exists?("help/(#{i}).txt")
      datei=File.new("help/(#{i}).txt")
      
      view.buffer.text=buffer + "\n\n"
      
      zeile=datei.gets
      while zeile != nil
        if zeile.chomp == "{"
          begin
            line=datei.gets
            if line.chomp != "}" and line[0..0] != "#"
              image=Gdk::Pixbuf.new(datei.gets.chomp)
              
              iter=view.buffer.get_iter_at_line(line.to_i + 2)
              view.buffer.insert(iter,image)
            end
          end until line.chomp == "}"
          
        elsif zeile[0..0] != "#"
          view.buffer.text += zeile
        end
        
        zeile=datei.gets
      end
      datei.close
    else
      view.buffer.text="No help for topic  \"#{help_text[i]}\"  vorhanden"
    end
    sw=ScrolledWindow.new
    sw.set_policy(POLICY_AUTOMATIC,POLICY_AUTOMATIC)
    sw.add(view)
    
    label_box=HBox.new
    icon=Image.new(Closed)
    label_box.pack_start(icon)
    icon.set_padding(3,1)
    label=Label.new(buffer)
    label_box.pack_start(label)
    label_box.show_all
    
    @notebook.append_page_menu(sw,label_box,nil)
    }
  end
  
  def set_page_pixmaps(notebook,page_num,pic)
    child=notebook.get_nth_page(page_num)
    label=notebook.get_tab_label(child).children[0].set(pic)
  end
  
  def page_switch(notebook,page,page_num)
    old_page_num=notebook.page
    set_page_pixmaps(notebook,page_num,Opened)
    set_page_pixmaps(notebook,old_page_num,Closed)
  end
end

