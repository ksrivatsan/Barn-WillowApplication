class VisitorsController < ApplicationController

	def index
		@add_button = "visible"
		@remove_button = "none";
		@fabrics = Fabric.all
		@referred_by_id = params[:referred_by_id]
	end
end
