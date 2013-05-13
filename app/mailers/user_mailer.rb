class UserMailer < ActionMailer::Base
  default from: "sales@aetravelusa.com"

  def welcome_email(user)
    @user = user
    @url = 'http://aetravelusa.com'
    mail(:to => user.email, :subject => 'Welcome to AE Travel site')
  end

  def test_email(employee_info)
    @employee_info = employee_info
    @url = 'http://aetravelusa.com/omeiadmin'
    mail(:to => employee_info.default_email, :subject => 'Test email') if employee_info.default_email
  end
end

