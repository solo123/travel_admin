  module SearchHelper
    def search_options
      options = {}
      return options if params[:q].nil?
      params[:q].each do |name, value|
        options["q[#{name}]"] = value
      end
      options
    end
  end
