puts "Deleting users"
User.unscoped.delete_all

puts "Creating admin user"
User.create! email: "admin@site.com", password: "admin", password_confirmation: "admin", role: "admin"