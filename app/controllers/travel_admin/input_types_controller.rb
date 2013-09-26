module TravelAdmin
	class InputTypesController < ResourceController
	end
  private
    def input_type_params
      params.require(:input_type).permit(:type_name, :type_text, :type_value, :status)

end
