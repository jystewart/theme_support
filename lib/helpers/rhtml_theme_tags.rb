#
# These are theme helper tags
#
module ActionView::Helpers::AssetTagHelper

   # returns the public path to a theme stylesheet
   def theme_stylesheet_path( source=nil, theme=nil )
      theme = theme || controller.current_theme
      compute_public_path(source || "theme", "themes/#{theme}/stylesheets", 'css')
   end

   # returns the path to a theme image
   def theme_image_path( source, theme=nil )
      theme = theme || controller.current_theme
      compute_public_path(source, "themes/#{theme}/images", 'png')
   end

   # returns the path to a theme javascript
   def theme_javascript_path( source, theme=nil )
      theme = theme || controller.current_theme
      compute_public_path(source, "themes/#{theme}/javascript", 'js')
   end

   # This tag it will automatially include theme specific css files
   def theme_stylesheet_link_tag(*sources)
      sources.uniq!
      options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }
      themed_sources = sources.collect { |source| theme_stylesheet_path(source) }
      stylesheet_link_tag(themed_sources)
   end
   
   # This tag will return a theme-specific IMG
   def theme_image_tag(source, options = {})
     options.symbolize_keys

     options[:src] = theme_image_path(source)
     options[:alt] ||= File.basename(options[:src], '.*').split('.').first.capitalize

     if options[:size]
       options[:width], options[:height] = options[:size].split("x")
       options.delete :size
     end

     tag("img", options)
   end
   
   # This tag can be used to return theme specific javascript files
   def theme_javascript_include_tag(*sources)
     options = sources.last.is_a?(Hash) ? sources.pop.stringify_keys : { }

     if sources.include?(:defaults)        
       pre_default_sources = sources[0..(sources.index(:defaults))]
       post_default_sources = sources[(sources.index(:defaults) + 1)..sources.length]
       sources = pre_default_sources + @@javascript_default_sources.dup + post_default_sources
       sources.delete(:defaults) 
       
       sources << "application" if defined?(Rails.root) && File.exists?("#{Rails.root}/public/javascripts/application.js") 
     end

     themed_sources = sources.collect { |source| theme_javascript_path(source) }
     javascript_include_tag(themed_sources)
   end

end