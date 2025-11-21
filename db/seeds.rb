# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user
admin = User.find_or_initialize_by(email: "admin@bagbuddy.com.np")
if admin.new_record?
  admin.password = "nopass@1234"
  admin.password_confirmation = "nopass@1234"
  admin.first_name = "Admin"
  admin.last_name = "User"
  admin.confirmed_at = Time.current # Skip email confirmation for seed
  admin.save!
  puts "✅ Created admin user: admin@bagbuddy.com.np / password"
else
  puts "ℹ️  Admin user already exists"
end

# Create initial application settings
ApplicationSetting.find_or_create_by(
  key: "low_stock_threshold",
  value: 1,
  description: "Minimum stock quantity before alerting low stock"
)
ApplicationSetting.find_or_create_by(
  key: "default_markup_percentage",
  value: 50.0,
  description: "Default markup percentage for auto-suggested selling price"
)
ApplicationSetting.find_or_create_by(
  key: "default_discount_percentage",
  value: 50.0,
  description: "Default discount percentage applied to products"
)

puts "✅ Created application settings"
puts "✅ Seed data completed!"
