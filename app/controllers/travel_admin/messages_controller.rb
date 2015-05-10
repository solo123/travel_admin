module TravelAdmin
  class MessagesController < ResourceController
		after_filter :send_message, only: [:create, :update]
		after_filter :mark_read, only: :show
		

		private
		  def load_collection
				pages = $redis.get :admin_list_per_page
				if params[:m] == 'draft'
					@collection = current_employee.employee_info.messages.draft.paginate(page: params[:page], per_page: pages)
				elsif params[:m] == 'sent'
					@collection = current_employee.employee_info.messages.sent.paginate(page: params[:page], per_page: pages)
				else
					@collection = current_employee.employee_info.message_receipts.paginate(page: params[:page], per_page: pages)
				end
			end
			def send_message
				if params[:commit] == 'Send'
					if @object.message_title.empty?
						flash[:error] = "Please input the message Title"
					elsif @object.send_to.empty?
						flash[:error] = "Please select at least one send to user"
					else
						@object.send_message
					end
				end
			end
			def mark_read
				@object.message_receipts.where(employee_info: current_employee.employee_info).each do |r|
					if r.status == 0
						r.status = 1
						r.save
					end
				end
			end
  end
end

