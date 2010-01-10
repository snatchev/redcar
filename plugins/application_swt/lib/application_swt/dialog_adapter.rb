module Redcar
  class ApplicationSWT
    class DialogAdapter
      def open_file(window, options)
        file_dialog(window, Swt::SWT::OPEN, options)
      end
      
      def open_directory(window, options)
        directory_dialog(window, options)
      end
      
      def save_file(window, options)
        file_dialog(window, Swt::SWT::SAVE, options)
      end
      
      MESSAGE_BOX_TYPES = {
        :info     => Swt::SWT::ICON_INFORMATION,
        :error    => Swt::SWT::ICON_ERROR,
        :question => Swt::SWT::ICON_QUESTION,
        :warning  => Swt::SWT::ICON_WARNING,
        :working  => Swt::SWT::ICON_WORKING
      }
      
      BUTTONS = {
        :yes    => Swt::SWT::YES,
        :no     => Swt::SWT::NO,
        :cancel => Swt::SWT::CANCEL,
        :retry  => Swt::SWT::RETRY,
        :ok     => Swt::SWT::OK,
        :abort  => Swt::SWT::ABORT,
        :ignore => Swt::SWT::IGNORE
      }
      
      MESSAGE_BOX_BUTTON_COMBOS = {
        :ok                 => [:ok],
        :ok_cancel          => [:ok, :cancel],
        :yes_no             => [:yes, :no], 
        :yes_no_cancel      => [:yes, :no, :cancel],
        :retry_cancel       => [:retry, :cancel],
        :abort_retry_ignore => [:abort, :retry, :ignore]
      }
      
      def message_box(window, text, options)
        styles = 0
        styles = styles | MESSAGE_BOX_TYPES[options[:type]] if options[:type]
        if options[:buttons]
          buttons = MESSAGE_BOX_BUTTON_COMBOS[options[:buttons]]
          buttons.each {|b| styles = styles | BUTTONS[b] }
        end
        dialog = Swt::Widgets::MessageBox.new(window.controller.shell, styles)
        dialog.set_message(text)
        result = dialog.open
        BUTTONS.invert[result]
      end
      
      def buttons
        BUTTONS.keys
      end
      
      def available_message_box_types
        MESSAGE_BOX_TYPES.keys
      end
      
      def available_message_box_button_combos
        MESSAGE_BOX_BUTTON_COMBOS.keys
      end
      
      private
      
      def file_dialog(window, type, options)
        dialog = Swt::Widgets::FileDialog.new(window.controller.shell, type)
        if options[:filter_path]
          dialog.set_filter_path(options[:filter_path])
        end
        dialog.open
      end
      
      def directory_dialog(window, options)
        dialog = Swt::Widgets::DirectoryDialog.new(window.controller.shell)
        if options[:filter_path]
          dialog.set_filter_path(options[:filter_path])
        end
        dialog.open
      end
    end
  end
end