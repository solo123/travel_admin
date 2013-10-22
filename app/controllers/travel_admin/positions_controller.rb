module TravelAdmin
  class PositionsController < ResourceController
    private
    def position_params
      params.require(:position).permit(:title, :status)
    end
  end
end
