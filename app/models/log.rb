class Log < ActiveRecord::Base
  belongs_to :employee_info
  belongs_to :ref_data, :polymorphic => true

  def self.last_operations(employee_info)
    self.where(:employee_info_id => employee_info.id).order('created_at desc').limit(5)
  end
end
