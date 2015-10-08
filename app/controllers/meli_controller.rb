# This two gems are important, JSON for parsing the response of the query and MELI for loading the MercadoLibre's Ruby SDK
require 'json'
require 'meli'
class MeliController < ApplicationController
  def meli
    #Let's do a query, first of all, we need something to look for, so we're going to get the input of the form located at index#index.html.erb
    @queryitem = params[:item]
    #We need to create a Meli object, initialiazed with our application's ID and secret key
    #For this scope in particular, this data is useless as this GET call doesn't need permissions at all.
    #Look for scopes in developers.mercadolibre.com, in SDK Directory
    meli = Meli.new(1347329944464828,"NSlACWY5RtCDSJgi1AHcQBbU1054EQnt")
    #Now, the query, let's call the get method from meli
    response = meli.get("sites/MLM/search?q=#{@queryitem}")
    #we got our response, so now let's parse it to JSON
    res = JSON.parse response.body
    #now let's make this JSON into a Ruby HASH
    reshash = Hash.try_convert(res)
    #reshash contains our response, but the actuall items founded are in another hash, stored in the key "results"
    resultitems = reshash["results"]
    #This array will create the local variable for printing in the view
    @items = Array.new

    resultitems.each do |item|
      #Let's create (another, *sigh*) hash for every result
      chash = Hash.try_convert(item)
      #Now, assign some attributes to variables
      name = chash["title"]
      condition = chash["condition"]
      price = chash["price"]
      thumbnail = chash["thumbnail"]
      #Finally, creating an Item object (see Item class, located at the end of this file)
      item = Item.new(name, condition, price, thumbnail)
      #Now, the Item is created and added into the Array
      @items.push(item)
      #Finally, set the variables blank for reuse in the next item found
      item = nil
      name = nil
      condition = nil
      price = nil
      chash = nil
    end
  end
end

#Placeholder for the Item object
class Item
  #Here, we specify the attributes we're are going to "return"
  attr_reader :name, :condition, :price, :thumbnail
  #Constructor
  def initialize(name, condition, price, thumbnail)
    @name = name
    @condition = condition
    @price = price
    @thumbnail = thumbnail
  end
end
