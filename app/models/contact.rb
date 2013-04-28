class Contact < ActiveRecord::Base
	belongs_to :company
  has_many :telephones, :as => :tel_number, :dependent => :destroy
  has_many :emails, :as => :email_data, :dependent => :destroy
  def to_s(spliter = "\n")
    r = [self.contact_name]
    self.telephones.each { |tel| r << tel }
    self.emails.each {|email| r << email }
    r.join(spliter)
  end
end
