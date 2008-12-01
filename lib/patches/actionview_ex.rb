# Extending <tt>ActionView::Base</tt> to support rendering themes
#
module ActionView
  
  # Extending <tt>ActionView::Base</tt> to support rendering themes
  class Base

  alias_method :theme_support_old_pick_template, :_pick_template
  
  private
    def _pick_template(template_path)
      search_path = [
        "#{RAILS_ROOT}/themes/#{controller.current_theme}/views",       # for components
        "#{RAILS_ROOT}/themes/#{controller.current_theme}",             # for layouts
      ]
      return template_path if template_path.respond_to?(:render)

      path = template_path.sub(/^\//, '')
      if m = path.match(/(.*)\.(\w+)$/)
        template_file_name, template_file_extension = m[1], m[2]
      else
        template_file_name = path
      end
    
      themed_file = File.join(search_path[0], "#{template_file_name}.#{template_format}.erb")
      if File.exists?(themed_file)
        return Template.new(themed_file, search_path)
      else
        return theme_support_old_pick_template(template_path)
      end
    end
  
  # def force_liquid?
  #   unless controller.nil?
  #     if controller.respond_to?('force_liquid_template')
  #       controller.force_liquid_template
  #     end
  #   else
  #     false
  #   end
  # end

  # def get_current_theme(local_assigns)
  #   unless controller.nil?
  #     if controller.respond_to?('current_theme')
  #       return controller.current_theme || false
  #     end
  #   end
  #   # Used with ActionMailers
  #   if local_assigns.include? :current_theme 
  #     return local_assigns.delete :current_theme
  #   end
  # end
  end
end
