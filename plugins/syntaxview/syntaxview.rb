
require File.dirname(__FILE__) + '/sourceview'

module Redcar
  module Plugins
    module SyntaxView
      extend FreeBASE::StandardPlugin
      extend Redcar::PreferencesBuilder
      
      preference "Appearance/Tab Theme" do |p|
        p.type = :combo
        p.default = "Mac Classic"
        p.values = fn { Theme.theme_names }
        p.change do 
          Redcar.current_window.all_tabs.each do |tab|
            if tab.respond_to? :sourceview
              tab.sourceview.set_theme(Theme.theme(Redcar.preference("Appearance/Tab Theme")))
            end
          end
        end
      end
      
      preference "Appearance/Entry Theme" do |p|
        p.type = :combo
        p.default = "Mac Classic"
        p.values = fn { Theme.theme_names }
      end
    
      def self.load(plugin)
        Redcar::SyntaxSourceView.init(:bundles_dir => "textmate/Bundles/",
                                      :themes_dir  => "textmate/Themes/",
                                      :cache_dir   => "cache/")
        
        plugin.transition(FreeBASE::LOADED)
      end
      
      def self.start(plugin)
        gtk_hbox = $BUS['/redcar/gtk/layout/status_hbox'].data
        gtk_combo_box = Gtk::ComboBox.new(true)
        list = Redcar::SyntaxSourceView.grammar_names.sort
        list.each {|item| gtk_combo_box.append_text(item) }
        gtk_combo_box.signal_connect("changed") do |gtk_combo_box1|
          Redcar.current_tab.sourceview.set_grammar(Redcar::SyntaxSourceView.grammar(:name => list[gtk_combo_box1.active]))
        end
        gtk_hbox.pack_end(gtk_combo_box, false)
        gtk_combo_box.show
        
        plugin.transition(FreeBASE::RUNNING)
      end
    end
  end
end
