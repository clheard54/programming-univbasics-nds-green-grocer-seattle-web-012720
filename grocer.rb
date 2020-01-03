def find_item_by_name_in_collection(name, collection)
cart_index = 0
  while cart_index < collection.length do
    if collection[cart_index][:item].downcase === name.downcase
      return collection[cart_index]
    else
      cart_index +=1
    end
  end
  return nil
end

def consolidate_cart(collection)
  receipt_items = []
  index = 0
  while index < collection.length do
    count = 0
    collection.each {|thing|
      if collection[index][:item] == thing[:item]
        count +=1
      end
    }
    collection[index][:count]= count
    if !receipt_items.include?(collection[index])
      puts collection[index][:count]
      receipt_items << collection[index]
    end
    index+=1
  end
  receipt_items
end

def apply_coupons(test_cart, coupons)
  test_cart = consolidate_cart(test_cart)
  #loop thru coupons
  coupon_index = 0
  while coupon_index < coupons.length do
    #loop through test_cart
    cart_index = 0
    while cart_index < test_cart.length do
      #compare coupons[coupon_index][:item] to each item in test_cart
      #2 cases:
      if coupons[coupon_index][:item] == test_cart[cart_index][:item]
        count_discounted = 0
        if test_cart[cart_index][:count] >= coupons[coupon_index][:num]
          while test_cart[cart_index][:count] >= coupons[coupon_index][:num] do 
            test_cart[cart_index][:count] -= coupons[coupon_index][:num]
           count_discounted += coupons[coupon_index][:num]
            cost_per = coupons[coupon_index][:cost]/coupons[coupon_index][:num].round(2)
          end
          coupon_hash = {
           :item => "#{test_cart[cart_index][:item]} W/COUPON",
           :price => cost_per,
           :clearance => test_cart[cart_index][:clearance],
           :count => count_discounted
           }
          test_cart << coupon_hash
        end
      end
    cart_index +=1 
    end
  coupon_index +=1 
  end
  return test_cart
end


def apply_clearance(cart)
  updated_cart = consolidate_cart(cart)
  #loop through updated_cart
  index = 0
  while index < updated_cart.length do
    if updated_cart[index][:clearance]
      new_price = (0.8)*updated_cart[index][:price]
      new_price = new_price.round(2)
      updated_cart[index][:price] = new_price
    end
    index+=1
  end
  updated_cart
end


def checkout(cart, coupons)
  remove_duplicates = consolidate_cart(cart)
  use_coupons = apply_coupons(remove_duplicates, coupons)
  final_cart = apply_clearance(use_coupons)
  grand_total = 0
  item_index = 0
  while item_index < final_cart.length do
      item_total = final_cart[item_index][:price] * final_cart[item_index][:count]
      grand_total += item_total
      item_index +=1
  end
  grand_total = grand_total.round(2)
  if grand_total>100
    grand_total = ((0.9)*grand_total).round(2)
  end
  grand_total
end
