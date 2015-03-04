class Admin::ItemsController < Admin::BaseController

  private

  def copy_variables
    @items = @controller_resources
    @item = @controller_resource
  end

  def resource
    @resource ||= Admin::ItemResource.new(params)
  end

  def resource_params
    params.require(:item).permit(:name, :price, :description, :order_id)
  end
end
