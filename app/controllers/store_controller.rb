class StoreController < ApplicationController
  def index
    @products = Product.all
    @date = Time.now.strftime("%B %d, %Y")
    @time = Time.now.strftime("%I:%M %p")
  end

end
