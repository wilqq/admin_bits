class Admin::BaseController < ApplicationController
  include AdminBits::Controller

   def index
    @controller_resources = resource.fetch_for_index
  end

  def new
    @controller_resource = resource.resource.new
  end

  def create
    @controller_resource = resource.resource.new(resource_params)

    if @controller_resource.save
      flash[:notice] = "You have successfully created #{resource.resource.to_s}"
      redirect_to resource.path
    else
      flash[:alert] = "#{resource.resource.to_s} can't be created"
      render 'new'
    end
  end

  def edit
    @controller_resource = resource.resource.find(params[:id])
  end

  def update
    @controller_resource = resource.resource.find(params[:id])

    if @controller_resource.update_attributes(resource_params)
      flash[:notice] = "You have successfully updated #{resource.resource.to_s}"
      redirect_to resource.path
    else
      flash[:alert] = "#{resource.resource.to_s} can't be updated"
      render :edit
    end
  end

  def destroy
    @controller_resource = resource.resource.find(params[:id])

    @controller_resource.destroy
    flash[:notice] = "You have successfully deleted #{resource.resource.to_s}"
    redirect_to resource.path
  end

  private

  def render *args
    copy_variables
    super
  end
end
