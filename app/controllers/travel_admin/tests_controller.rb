module TravelAdmin
	class TestsController < AdminController
    def reset_app_session
      reset_session
      render :text => 'session reseted'
    end
	end
end

