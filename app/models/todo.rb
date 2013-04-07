class Todo < ActiveRecord::Base
  belongs_to :employee_info
  has_many :todo_workers, :dependent => :destroy
  has_many :remarks, :as => :note_data, :dependent => :destroy
end

