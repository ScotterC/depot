class StoreController < ApplicationController
  def index
    @products = Product.all
    @cart = current_cart
    @date = Time.now.strftime("%B %d, %Y")
    @time = Time.now.strftime("%I:%M %p")
    @count = increment_count
  end

  def increment_count
    session[:counter] ||= 0
    session[:counter] += 1
  end

end

