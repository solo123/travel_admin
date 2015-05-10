class Account < ActiveRecord::Base
  belongs_to :owner, :polymorphic => :true
  has_many :payments
  has_many :account_histories, :as => :balance_object

	def to_s
		if self.owner
			self.owner
		else
			"account:#{self.id}"
		end
	end
end

