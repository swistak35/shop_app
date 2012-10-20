class Admin::ApplicationController < ::ApplicationController
	layout 'admin/application'
	before_filter :authenticate_admin_admin!
end