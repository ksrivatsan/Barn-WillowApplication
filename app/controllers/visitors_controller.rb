class VisitorsController < ApplicationController

	def index
		@add_button = "visible"
		@remove_button = "none";
		@fabrics = Fabric.all
	end
end
