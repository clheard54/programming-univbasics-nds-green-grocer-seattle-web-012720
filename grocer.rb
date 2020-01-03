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

def apply_coupons(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_index= 0
  while coupon_index < coupons.length do
    cart_item = find_item_by_name_in_collection(coupons[coupon_index][:item], consolidated_cart)
    couponed_item_name = "#{coupons[coupon_index][:item]} W/COUPON"
    cart_item_with_coupon = find_item_by_name_in_collection(couponed_item_name, consolidated_cart)
    if cart_item && cart_item[:count] >= coupons[coupon_index][:num]
      if cart_item_with_coupon
        cart_item_with_coupon[:count] += coupons[coupon_index][:num]
        cart_item[:count] -= coupons[coupon_index][:num]
      else 
        cart_item_with_coupon = {
          :item => couponed_item_name,
          :price => coupons[coupon_index][:cost]/coupons[coupon_index][:num].round(2),
          :count => coupons[coupon_index][:num],
          :clearance => cart_item[:clearance]
        }
        consolidated_cart << cart_item_with_coupon
        cart_item[:count] -= coupons[coupon_index][:num]
      end
    end
    coupon_index += 1
  end
  consolidated_cart
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
