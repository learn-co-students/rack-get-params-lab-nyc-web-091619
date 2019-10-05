class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = [] # new class array to hold any items in your cart

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/) #new route to show items in cart
      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        @@cart.each do |item|
          resp.write "#{item}\n"
        end
      end
    elsif req.path.match(/add/) #takes in a GET param with key item
      item_to_add = req.params["item"]
      if @@items.include? item_to_add #check to see if item is in @@items
        @@cart << item_to_add #then add it to the cart if it is
        resp.write "added #{item_to_add}"
      else
        resp.write "We don't have that item!"
      end
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end