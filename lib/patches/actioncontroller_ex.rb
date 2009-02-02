# Extend the Base ActionController to support themes
ActionController::Base.class_eval do 

   attr_accessor :current_theme
   attr_accessor :force_liquid_template
   
   # Use this in your controller just like the <tt>layout</tt> macro.
   # Example:
   #
   #  theme 'theme_name'
   #
   # -or-
   #
   #  theme :get_theme
   #
   #  def get_theme
   #    'theme_name'
   #  end
   def self.theme(theme_name, conditions = {})
     # TODO: Allow conditions... (?)
     write_inheritable_attribute "theme", theme_name
   end
   
   # Retrieves the current set theme
   def current_theme(passed_theme=nil)
     theme = passed_theme || self.class.read_inheritable_attribute("theme")
     
     @active_theme = case theme
       when Symbol then send(theme)
       when Proc   then theme.call(self)
       when String then theme
     end
   end

end