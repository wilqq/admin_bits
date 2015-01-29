require 'rails/generators'
require 'rbconfig'

class AdminBitsGenerator < Rails::Generators::Base
  argument :resource,
    :type => :string,
    :required => true,
    :desc => "Name of the resource eg. 'products' will create 'namespace/products_controller.rb'"

  class_option :layout,
    :type => :string,
    :desc => "Name of the generated layout eg. 'admin' will be placed in 'app/views/layouts/admin.html.erb'",
    :aliases => '-L', :default => 'admin'
  class_option :namespace,
    :type => :string,
    :desc => "Name of the namespace for the generated controller eg. 'admin'",
    :aliases => '-NS', :default => 'admin'
  class_option :unify,
    :type => :boolean,
    :default => true,
    :desc => "Create special BaseController in the selected namespace",
    :aliases => '-U'
  class_option :routing,
    :type => :boolean,
    :default => true,
    :desc => "Add routing based on resource and namespace",
    :aliases => '-AR'

  self.source_paths << File.join(File.dirname(__FILE__), 'templates')

  def create_layout
    binding.pry
    template "layout.html.erb", "app/views/layouts/#{ layout }.html.erb"
  end

  def create_controller
    template "controller.rb.erb", "app/controllers/#{ namespace }/#{ controller_name }.rb"
  end

  def create_resource
    template "resource.rb.erb", "lib/#{ namespace }/#{ resource_name }.rb"
  end

  def create_base_controller
    if options[:unify]
      template "base_controller.rb.erb", "app/controllers/#{ namespace }/base_controller.rb"
    end
  end

  def add_routing
    if options[:add_routing]
      route("namespace :#{namespace} do \n    resources :#{resource} \n  end")
    end
  end

  protected

  def layout
    options[:layout]
  end

  def namespace
    options[:namespace]
  end

  def resource_name
    (resource.singularize + '_resource')
  end

  def controller_name
    (resource + '_controller')
  end
end
