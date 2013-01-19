class Admin::MainController < Admin::AdminController
	def index
    @name = Time.now.to_i.to_s
    #ChartFirst.new(@name)
	end
end