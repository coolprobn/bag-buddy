# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting seed data creation..."

# Create admin user
admin = User.find_or_initialize_by(email: "admin@bagbuddy.com.np")
if admin.new_record?
  admin.password = "nopass@1234"
  admin.password_confirmation = "nopass@1234"
  admin.first_name = "Admin"
  admin.last_name = "User"
  admin.phone = "+977-9841234567"
  admin.address = "Kathmandu, Nepal"
  admin.confirmed_at = Time.current # Skip email confirmation for seed
  admin.save!
  puts "✅ Created admin user: admin@bagbuddy.com.np / nopass@1234"
else
  puts "ℹ️  Admin user already exists"
end

# Create initial application settings
ApplicationSetting.find_or_create_by(key: "low_stock_threshold") do |setting|
  setting.value = "1"
  setting.field_type = "number_field"
  setting.description = "Minimum stock quantity before alerting low stock"
end

ApplicationSetting.find_or_create_by(
  key: "default_markup_percentage"
) do |setting|
  setting.value = "50.0"
  setting.field_type = "number_field"
  setting.description =
    "Default markup percentage for auto-suggested selling price"
end

ApplicationSetting.find_or_create_by(
  key: "default_discount_percentage"
) do |setting|
  setting.value = "10.0"
  setting.field_type = "number_field"
  setting.description = "Default discount percentage applied to products"
end

puts "✅ Created application settings"

# Create Vendors
vendors_data = [
  {
    name: "Leather Craft Nepal",
    phone: "+977-9841234567",
    address: "Thamel, Kathmandu",
    instagram_profile_url: "leathercraftnepal",
    facebook_url: "leathercraftnepal",
    whatsapp_number: "+977-9841234567",
    notes: "Premium leather supplier, reliable delivery"
  },
  {
    name: "Bag Wholesale Co.",
    phone: "+977-9842345678",
    address: "New Road, Kathmandu",
    instagram_profile_url: "bagwholesale",
    tiktok_profile_url: "bagwholesale",
    whatsapp_number: "+977-9842345678",
    notes: "Bulk orders available, good pricing"
  },
  {
    name: "Fashion Accessories Ltd",
    phone: "+977-9843456789",
    address: "Durbar Marg, Kathmandu",
    instagram_profile_url: "fashionaccessories",
    facebook_url: "fashionaccessories",
    notes: "Trendy designs, fast shipping"
  },
  {
    name: "Handmade Bags Nepal",
    phone: "+977-9844567890",
    address: "Patan, Lalitpur",
    instagram_profile_url: "handmadebagsnepal",
    tiktok_profile_url: "handmadebags",
    whatsapp_number: "+977-9844567890",
    notes: "Artisan made, unique designs"
  }
]

vendors = []
vendors_data.each do |vendor_data|
  vendor =
    Vendor.find_or_create_by(name: vendor_data[:name]) do |v|
      v.phone = vendor_data[:phone]
      v.address = vendor_data[:address]
      v.instagram_profile_url = vendor_data[:instagram_profile_url]
      v.tiktok_profile_url = vendor_data[:tiktok_profile_url]
      v.facebook_url = vendor_data[:facebook_url]
      v.whatsapp_number = vendor_data[:whatsapp_number]
      v.notes = vendor_data[:notes]
    end
  vendors << vendor
end
puts "✅ Created #{vendors.count} vendors"

# Create Products
products_data = [
  {
    name: "Classic Leather Tote Bag",
    description:
      "Premium genuine leather tote bag, perfect for daily use. Spacious interior with multiple pockets.",
    category: "Tote Bags",
    color_family: "Brown",
    stock_quantity: 15,
    current_cost_price: 2500.00,
    status: "active",
    vendor: vendors[0]
  },
  {
    name: "Designer Crossbody Bag",
    description:
      "Elegant crossbody bag with adjustable strap. Ideal for evening outings.",
    category: "Crossbody Bags",
    color_family: "Black",
    stock_quantity: 8,
    current_cost_price: 1800.00,
    status: "active",
    vendor: vendors[1]
  },
  {
    name: "Vintage Backpack",
    description:
      "Stylish vintage-style backpack with leather accents. Great for travel.",
    category: "Backpacks",
    color_family: "Tan",
    stock_quantity: 12,
    current_cost_price: 3200.00,
    status: "active",
    vendor: vendors[0]
  },
  {
    name: "Minimalist Clutch",
    description: "Sleek minimalist clutch bag. Perfect for formal events.",
    category: "Clutches",
    color_family: "Black",
    stock_quantity: 5,
    current_cost_price: 1200.00,
    status: "active",
    vendor: vendors[2]
  },
  {
    name: "Canvas Messenger Bag",
    description:
      "Durable canvas messenger bag with leather straps. Casual and functional.",
    category: "Messenger Bags",
    color_family: "Navy Blue",
    stock_quantity: 20,
    current_cost_price: 1500.00,
    status: "active",
    vendor: vendors[3]
  },
  {
    name: "Luxury Handbag",
    description:
      "High-end luxury handbag with premium materials. Limited edition.",
    category: "Handbags",
    color_family: "Burgundy",
    stock_quantity: 3,
    current_cost_price: 8500.00,
    status: "active",
    vendor: vendors[1]
  },
  {
    name: "Weekend Travel Bag",
    description:
      "Large travel bag perfect for weekend getaways. Multiple compartments.",
    category: "Travel Bags",
    color_family: "Gray",
    stock_quantity: 10,
    current_cost_price: 4500.00,
    status: "active",
    vendor: vendors[0]
  },
  {
    name: "Eco-Friendly Tote",
    description:
      "Sustainable eco-friendly tote bag made from recycled materials.",
    category: "Tote Bags",
    color_family: "Green",
    stock_quantity: 25,
    current_cost_price: 800.00,
    status: "active",
    vendor: vendors[3]
  },
  {
    name: "Designer Shoulder Bag",
    description:
      "Trendy shoulder bag with modern design. Perfect for fashion-forward individuals.",
    category: "Shoulder Bags",
    color_family: "Beige",
    stock_quantity: 0,
    current_cost_price: 2200.00,
    status: "draft",
    vendor: vendors[2]
  },
  {
    name: "Vintage Leather Satchel",
    description:
      "Classic leather satchel with timeless design. Handcrafted with attention to detail.",
    category: "Satchels",
    color_family: "Brown",
    stock_quantity: 1,
    current_cost_price: 3800.00,
    status: "active",
    vendor: vendors[0]
  }
]

products = []
products_data.each do |product_data|
  vendor = product_data.delete(:vendor)
  product =
    Product.find_or_create_by(name: product_data[:name]) do |p|
      p.description = product_data[:description]
      p.category = product_data[:category]
      p.color_family = product_data[:color_family]
      p.stock_quantity = product_data[:stock_quantity]
      p.current_cost_price = product_data[:current_cost_price]
      p.status = product_data[:status]
      p.current_vendor = vendor
      # Calculate auto-suggested selling price
      markup = ApplicationSetting.get("default_markup_percentage") || 50.0
      p.auto_suggested_selling_price =
        product_data[:current_cost_price] * (1 + markup.to_f / 100)
    end
  products << product

  # Create vendor price history
  VendorPriceHistory.find_or_create_by(
    product: product,
    vendor: vendor
  ) { |vph| vph.cost_price = product_data[:current_cost_price] }
end
puts "✅ Created #{products.count} products"

# Create Customers
customers_data = [
  {
    first_name: "Sita",
    last_name: "Shrestha",
    phone: "+977-9841111111",
    email: "sita.shrestha@example.com",
    instagram_profile_url: "sita_shrestha",
    whatsapp_number: "+977-9841111111",
    address: "Baneshwor, Kathmandu",
    notes: "Regular customer, prefers premium bags"
  },
  {
    first_name: "Ram",
    last_name: "Kumar",
    phone: "+977-9842222222",
    email: "ram.kumar@example.com",
    tiktok_profile_url: "ram_kumar",
    whatsapp_number: "+977-9842222222",
    address: "Lalitpur, Nepal",
    notes: "Interested in trendy designs"
  },
  {
    first_name: "Gita",
    last_name: "Tamang",
    phone: "+977-9843333333",
    email: "gita.tamang@example.com",
    instagram_profile_url: "gita_tamang",
    facebook_url: "gita.tamang",
    address: "Pokhara, Nepal",
    notes: "Prefers eco-friendly options"
  },
  {
    first_name: "Hari",
    last_name: "Poudel",
    phone: "+977-9844444444",
    email: "hari.poudel@example.com",
    whatsapp_number: "+977-9844444444",
    address: "Chitwan, Nepal",
    notes: "Bulk orders for business"
  },
  {
    first_name: "Maya",
    last_name: "Gurung",
    phone: "+977-9845555555",
    email: "maya.gurung@example.com",
    instagram_profile_url: "maya_gurung",
    tiktok_profile_url: "maya_gurung",
    address: "Bhaktapur, Nepal",
    notes: "Fashion influencer, frequent buyer"
  }
]

customers = []
customers_data.each do |customer_data|
  customer =
    Customer.find_or_create_by(email: customer_data[:email]) do |c|
      c.first_name = customer_data[:first_name]
      c.last_name = customer_data[:last_name]
      c.phone = customer_data[:phone]
      c.instagram_profile_url = customer_data[:instagram_profile_url]
      c.tiktok_profile_url = customer_data[:tiktok_profile_url]
      c.facebook_url = customer_data[:facebook_url]
      c.whatsapp_number = customer_data[:whatsapp_number]
      c.address = customer_data[:address]
      c.notes = customer_data[:notes]
    end
  customers << customer
end
puts "✅ Created #{customers.count} customers"

# Create Delivery Partners
delivery_partners_data = [
  {
    name: "Fast Delivery Nepal",
    default_cost: 150.00,
    contact_number: "+977-9801234567",
    notes: "Same day delivery available in Kathmandu"
  },
  {
    name: "Express Courier",
    default_cost: 200.00,
    contact_number: "+977-9802345678",
    notes: "Nationwide delivery, 2-3 days"
  },
  {
    name: "Local Delivery Service",
    default_cost: 100.00,
    contact_number: "+977-9803456789",
    notes: "Best for local Kathmandu deliveries"
  }
]

delivery_partners = []
delivery_partners_data.each do |dp_data|
  dp =
    DeliveryPartner.find_or_create_by(name: dp_data[:name]) do |d|
      d.default_cost = dp_data[:default_cost]
      d.contact_number = dp_data[:contact_number]
      d.notes = dp_data[:notes]
    end
  delivery_partners << dp
end
puts "✅ Created #{delivery_partners.count} delivery partners"

# Create Sales
sales = []
5.times do |i|
  product = products.sample
  customer = customers.sample
  delivery_partner = delivery_partners.sample

  selling_price =
    product.auto_suggested_selling_price || (product.current_cost_price * 1.5)
  quantity = [1, 1, 1, 2, 3].sample
  subtotal = selling_price * quantity
  discount_amount = [0, 0, subtotal * 0.1, subtotal * 0.15].sample.round(2)
  tax_amount = (subtotal - discount_amount) * 0.13 # 13% VAT
  delivery_cost = delivery_partner.default_cost
  total = (subtotal - discount_amount + tax_amount + delivery_cost).round(2)
  profit =
    (
      (selling_price - product.current_cost_price) * quantity - discount_amount
    ).round(2)

  sale =
    Sale.create!(
      product: product,
      customer: customer,
      delivery_partner: delivery_partner,
      selling_price: selling_price,
      quantity: quantity,
      subtotal: subtotal,
      discount_amount: discount_amount,
      tax_amount: tax_amount,
      delivery_cost: delivery_cost,
      total: total,
      profit: profit,
      payment_method: %w[cash online bank_transfer].sample,
      notes: i == 0 ? "First sale of the month" : nil,
      created_at: (5 - i).days.ago
    )
  sales << sale

  # Update product stock
  product.update(stock_quantity: product.stock_quantity - quantity)
end
puts "✅ Created #{sales.count} sales"

# Create Sales Returns
if sales.any?
  return_sale = sales.first
  SalesReturn.find_or_create_by(sale: return_sale) do |sr|
    sr.return_quantity = 1
    sr.refund_amount = return_sale.selling_price
    sr.reason = "Product defect, customer requested return"
    sr.created_at = 2.days.ago
  end
  puts "✅ Created 1 sales return"
end

# Create Exchanges
if sales.count >= 2 && products.count >= 2
  original_sale = sales.second
  replacement_product =
    products.reject { |p| p.id == original_sale.product.id }.sample

  Exchange.find_or_create_by(
    original_sale: original_sale,
    replacement_product: replacement_product
  ) do |e|
    price_diff =
      replacement_product.auto_suggested_selling_price -
        original_sale.selling_price
    e.price_difference = price_diff
    e.notes = "Customer preferred different color"
    e.created_at = 1.day.ago
  end
  puts "✅ Created 1 exchange"
end

# Create Expenses
expenses_data = [
  {
    category: "rent",
    amount: 25000.00,
    description: "Monthly shop rent",
    created_at: 1.month.ago
  },
  {
    category: "ads",
    amount: 5000.00,
    description: "Facebook and Instagram ads campaign",
    created_at: 15.days.ago
  },
  {
    category: "packaging",
    amount: 3000.00,
    description: "Gift boxes and wrapping materials",
    created_at: 10.days.ago
  },
  {
    category: "misc",
    amount: 2000.00,
    description: "Office supplies and utilities",
    created_at: 5.days.ago
  },
  {
    category: "ads",
    amount: 3500.00,
    description: "TikTok influencer collaboration",
    created_at: 3.days.ago
  }
]

expenses_data.each do |expense_data|
  Expense.find_or_create_by(
    category: expense_data[:category],
    amount: expense_data[:amount],
    description: expense_data[:description],
    created_at: expense_data[:created_at]
  )
end
puts "✅ Created #{expenses_data.count} expenses"

# Create Social Media Posts
social_posts_data = [
  {
    title: "New Collection Launch",
    content:
      "Excited to announce our new premium leather collection! Handcrafted with love in Nepal. #BagBuddy #LeatherBags #NepalMade",
    hashtags: %w[BagBuddy LeatherBags NepalMade Handcrafted],
    platforms_posted: %w[instagram facebook],
    post_url_per_platform: {
      "instagram" => "https://instagram.com/p/abc123",
      "facebook" => "https://facebook.com/posts/xyz789"
    },
    metadata: {
      engagement_rate: 4.5,
      reach: 5000
    },
    created_at: 7.days.ago
  },
  {
    title: "Eco-Friendly Tote Bags",
    content:
      "Check out our sustainable eco-friendly tote bags! Made from recycled materials. #EcoFriendly #SustainableFashion #GreenLiving",
    hashtags: %w[EcoFriendly SustainableFashion GreenLiving Recycled],
    platforms_posted: %w[instagram tiktok],
    post_url_per_platform: {
      "instagram" => "https://instagram.com/p/def456",
      "tiktok" => "https://tiktok.com/@bagbuddy/video/123"
    },
    metadata: {
      engagement_rate: 6.2,
      reach: 8000
    },
    created_at: 5.days.ago
  },
  {
    title: "Weekend Sale Alert",
    content:
      "Weekend special! 15% off on all crossbody bags. Limited stock available. Shop now! #Sale #WeekendDeals #Fashion",
    hashtags: %w[Sale WeekendDeals Fashion Discount],
    platforms_posted: %w[facebook instagram],
    post_url_per_platform: {
      "facebook" => "https://facebook.com/posts/sale123",
      "instagram" => "https://instagram.com/p/sale456"
    },
    metadata: {
      engagement_rate: 8.1,
      reach: 12_000
    },
    created_at: 2.days.ago
  }
]

social_posts_data.each do |post_data|
  SocialMediaPost.find_or_create_by(
    title: post_data[:title],
    created_at: post_data[:created_at]
  ) do |post|
    post.content = post_data[:content]
    post.hashtags = post_data[:hashtags]
    post.platforms_posted = post_data[:platforms_posted]
    post.post_url_per_platform = post_data[:post_url_per_platform]
    post.metadata = post_data[:metadata]
  end
end
puts "✅ Created #{social_posts_data.count} social media posts"

puts ""
puts "🎉 Seed data completed successfully!"
puts "   - #{vendors.count} vendors"
puts "   - #{products.count} products"
puts "   - #{customers.count} customers"
puts "   - #{delivery_partners.count} delivery partners"
puts "   - #{sales.count} sales"
puts "   - #{SalesReturn.count} sales returns"
puts "   - #{Exchange.count} exchanges"
puts "   - #{Expense.count} expenses"
puts "   - #{SocialMediaPost.count} social media posts"
