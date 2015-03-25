module TravelAdmin
  class PhotosController < AdminController
    def index
      load_parent
      load_collection
    end
    def show
      load_parent
      load_object
    end
    def new
      load_parent
      @object = @parent.photos.build
    end
    def edit
      load_parent
      load_object
    end
    def update
      load_parent
      load_object
		  params.permit!
      @object = update_attributes(params[:photo])
    end
    def create
      load_parent
      if params[:data]
        dt = JSON.parse params[:data]
        dt.each do |d|
          pic = @parent.photos.build(d)
          pic.save
          flash[:notice] ||= []
          flash[:notice] << "pic added to #{@parent.to_s}"
        end
      end
    end
    def destroy
      load_object
      @object.destroy
      redirect_to :action => :index
    end

    def cover
      load_parent
      load_object
      @parent.title_photo_id = params[:id]
      @parent.save
      redirect_to :action => :index
    end


    protected
    def load_collection
      @collection = @parent.photos if @parent
    end
    def load_object
      @object = Photo.find(params[:id])
    end
    def load_parent
      @parent = if params[:company_id]
                  Company.find(params[:company_id])
                elsif params[:bus_id]
                  Bus.find(params[:bus_id])
                elsif params[:destination_id]
                  Destination.find(params[:destination_id])
                elsif params[:user_info_id]
                  UserInfo.find(params[:user_info_id])
                elsif params[:employee_info_id]
                  EmployeeInfo.find(params[:employee_info_id])
                elsif params[:page_id]
                  Page.find(params[:page_id])
                end
    end

    private
    def photo_params
      params.require(:photo).permit(:pic)
    end
  end
end
