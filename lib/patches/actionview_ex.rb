# Extending <tt>ActionView::Base</tt> to support rendering themes
#
module ActionView
  
  # Extending <tt>ActionView::Base</tt> to support rendering themes
  class Base
    alias_method :theme_support_old_render_file, :render_file
      # Overrides the default <tt>Base#render_file</tt> to allow theme-specific views
    def render_file(template_path, use_full_path = false, local_assigns = {})

      search_path = [
      "#{RAILS_ROOT}/themes/#{controller.current_theme}/views",       # for components
      "#{RAILS_ROOT}/themes/#{controller.current_theme}",             # for layouts
      ]

      @finder.prepend_view_path(search_path)
      local_assigns['active_theme'] = get_current_theme(local_assigns)
      theme_support_old_render_file(template_path, use_full_path, local_assigns)
        
      end      
  private

  def force_liquid?
    unless controller.nil?
      if controller.respond_to?('force_liquid_template')
        controller.force_liquid_template
      end
    else
      false
    end
  end

  def get_current_theme(local_assigns)
    unless controller.nil?
      if controller.respond_to?('current_theme')
        return controller.current_theme || false
      end
    end
    # Used with ActionMailers
    if local_assigns.include? :current_theme 
      return local_assigns.delete :current_theme
    end
  end
  end
end
