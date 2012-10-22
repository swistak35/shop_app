namespace :extra do
	desc "Setup example shop application"
	task :setup => :environment do
		printf "Creating admin user... "
		admin = Admin.new
		admin.email = "admin@admin.pl"
		admin.password = "adminqwerty"
		admin.save
		puts "done."

		printf "Creating example categories... "
		@cat_teas = Category.create(name: "Teas")
		@cat_accessories = Category.create(name: "Accessories")
		puts "done."

		printf "Creating example products... "
		Product.create(name: "Black tea", desc: "Tasty!", price: 9.99, category_id: @cat_teas.id)
		Product.create(name: "Green tea", desc: "Healthy!", price: 14.99, category_id: @cat_teas.id)
		Product.create(name: "Blue tea", desc: "Just kiddin'. Blue tea doesn't exist.", price: 29.49, category_id: @cat_teas.id)
		Product.create(name: "Teaspoon", desc: "Wooden teaspoon", price: 2.99, category_id: @cat_accessories.id)
		puts "done."

		puts "-----------------------------"
		puts "Setup finished!"
		puts "Admin e-mail: admin@admin.pl"
		puts "Admin password: adminqwerty"
		puts "Good luck!"
		puts "-----------------------------"
	end

	desc "Delete all records"
	task :reset => :environment do
		printf "Deleting records... "
		Admin.delete_all
		Category.delete_all
		Product.delete_all
		Order.delete_all
		OrderItem.delete_all
		Buyer.delete_all
		Address.delete_all
		puts "done."
		puts "IMPORTANT! Clear your cookies, because they keep buyer_id, which isn't exist anymore. I know, it's a bug. Or maybe it's a feature."
	end
end