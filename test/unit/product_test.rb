require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end
  
  test "product price must be positive" do
    product = Product.new(
      :title => "My Book Title", 
      :description => "yyy", 
      :image_url => "zzz.jpg")
    
    product.price = -1
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    
    product.price = 0
    assert product.invalid?
    assert_equal "must be greater than or equal to 0.01", product.errors[:price].join('; ')
    
    product.price = 1
    assert product.valid?
  end
  
  def new_product_image(image_url)
    Product.new(
      :title => "My Book Title", 
      :description => "yyy",
      :price  => 1, 
      :image_url => image_url)
  end
  
  test "image url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG Fred.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product_image(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert new_product_image(name).invalid?, "#{name} shouldn't be valid"
    end
    
  end
  
  test "product is not valid without a unique title" do
    product = Product.new(:title       => products(:ruby).title,
                          :description => "yyy", 
                          :price       => 1, 
                          :image_url   => "fred.gif")

    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end

  test "product is not valid without a unique title - i18n" do
    product = Product.new(:title       => products(:ruby).title,
                          :description => "yyy", 
                          :price       => 1, 
                          :image_url   => "fred.gif")

    assert !product.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'),
                 product.errors[:title].join('; ')
  end
  
  def new_product_title(title)
    Product.new(
      :title => title, 
      :description => "yyy",
      :price  => 1, 
      :image_url => "fred.gif")
  end
  
  test "product title must be at least 10 characters" do
    good_title = "Long titles"
    bad_title = "bad"
    
    assert new_product_title(good_title).valid?
    assert new_product_title(bad_title).invalid?
  end
  
  
  
end
