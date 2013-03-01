namespace :extra do
	desc "Setup example shop application"
	task :setup => :environment do
		printf "Creating admin user... "
		admin = Admin.new
		admin.email = "admin@admin.pl"
		admin.password = "adminqwerty"
		admin.save
		puts "done."
		
		# printf "Creating example categories... "
		# Category.create(name: "Teas")
		# Category.create(name: "Accessories")
		# puts "done."

		# printf "Creating example products... "
		# Product.create(name: "Black tea", desc: "Tasty!", price: 9.99, category_id: @cat_teas.id)
		# Product.create(name: "Green tea", desc: "Healthy!", price: 14.99, category_id: @cat_teas.id)
		# Product.create(name: "Blue tea", desc: "Just kiddin'. Blue tea doesn't exist.", price: 29.49, category_id: @cat_teas.id)
		# Product.create(name: "Teaspoon", desc: "Wooden teaspoon", price: 2.99, category_id: @cat_accessories.id)
		# puts "done."

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

	desc "Add fake records"
	task :fake_data => :environment do
		# fake categories
		print "Creating fake categories... "
		10.times do
			Category.create name: Faker::Lorem.words(2).join(' ').capitalize
		end
		puts "done."
		
		# fake products
		print "Creating fake products... "
		@categories = Category.all
		100.times do
			Product.create 	name: Faker::Lorem.words(4, true).join(' ').capitalize,
											desc: Faker::Lorem.paragraphs(2).join(' '),
											price: (rand(10000).to_f / 100),
											category_id: @categories.sample.id
		end
		puts "done."
		
		# fake buyers & orders
		print "Creating fake buyers & orders... "
		@products = Product.all
		40.times do
			buyer = Buyer.create
			# kazdy kupujący losowo 0..3 zamówień
			amount_of_orders = rand(4)
			amount_of_orders.times do
				order = buyer.orders.create

				amount_of_items = rand(12) + 1
				amount_of_items.times do
					order.add_product @products.sample, (rand(10) + 1)
				end

				order.create_address 	first_name: Faker::Name.first_name,
															last_name: Faker::Name.last_name

				if rand(3) > 0
					order.complete!
				end

				order.save
			end
		end
		puts "done."
	end
end