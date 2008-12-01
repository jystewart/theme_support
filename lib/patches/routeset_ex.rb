# Extends <tt>ActionController::Routing::RouteSet</tt> to automatically add the theme routes
# class ActionController::Routing::RouteSet
# 
#   alias_method :__draw, :draw
# 
#   # Overrides the default <tt>RouteSet#draw</tt> to automatically
#   # include the routes needed by the <tt>ThemeController</tt>
#   def draw
#     clear!
#     map = Mapper.new(self)
# 
#     create_theme_routes(map)
#     yield map
# 
#     named_routes.install
#   end
# 
#   # Creates the required routes for the <tt>ThemeController</tt>...
#   def create_theme_routes(map)
#     map.theme_images "/themes/:theme/images/*filename", :controller=>'theme', :action=>'images'
#     map.theme_stylesheets "/themes/:theme/stylesheets/*filename", :controller=>'theme', :action=>'stylesheets'
#     map.theme_javascript "/themes/:theme/javascript/*filename", :controller=>'theme', :action=>'javascript'
#     map.connect "/themes/*whatever", :controller=>'theme', :action=>'error'
#   end
# 
# end