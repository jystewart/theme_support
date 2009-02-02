# Extend the Base ActionController to support themes
ActionMailer::Base.class_eval do 
  
  alias_method :__render, :render
  alias_method :__initialize, :initialize
  
  @current_theme = nil
  
  attr_reader :current_theme
   
  def initialize(method_name=nil, *parameters)
    if parameters[-1].is_a? Hash and (parameters[-1].include? :theme)
      @current_theme = parameters[-1][:theme]
      parameters[-1].delete :theme
      parameters[-1][:current_theme] = @current_theme
    end
    create!(method_name, *parameters) if method_name
  end
  
  def render(opts)
    body = opts.delete(:body)
    body[:current_theme] = @current_theme
    if opts[:file] && (opts[:file] !~ /\// && !opts[:file].respond_to?(:render))
      opts[:file] = "#{mailer_name}/#{opts[:file]}"
    end

    raise opts[:file].inspect

    begin
      old_template, @template = @template, initialize_template_class(body)
      layout = respond_to?(:pick_layout, true) ? pick_layout(opts) : false
      @template.render(opts.merge(:layout => layout))
    ensure
      @template = old_template
    end
  end
  # 
  # def render(opts)
  #   body = opts.delete(:body)
  #   body[:current_theme] = @current_theme
  #   opts[:file] = "#{mailer_name}/#{opts[:file]}"
  #   initialize_template_class(body).render(opts)
  # end
   
end