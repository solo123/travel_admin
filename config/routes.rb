TravelAdmin::Engine.routes.draw do

  get "pages/temp"
  resources :destinations do
    resources :photos do
      member do
        get :cover
      end
    end
  end
  resources :pages do
    resources :photos
  end
  resources :buses do
    resources :photos do
      get :cover, :on => :member
    end
    resources :bus_reserved_dates
    get :shift, :on => :member
    get :shifts, :on => :collection
  end
  resources :tours do
    resources :spots, :controller => 'tours/spots'
    collection do
      get :search, :generate
    end
    get :gen, :on => :member
    resources :schedules
  end
  resources :schedules do
    collection do
      get :select, :search, :generate
      put :selected
    end
    member do
      get :orders
    end
    resources :schedule_assignments do
      resources :bus_seats
      patch :seats, :on => :member
    end
  end
  resources :user_infos do
    collection do
      get :select, :find, :search, :add_tel, :add_email, :add_address, :brief
      get :autocomplete_user_info_search
    end
    resources :photos do
      get :cover, :on => :member
    end
  end
  resources :emails, :telephones, :addresses
  resources :orders do
    get :add_room, :on => :member
    resources :remarks
    resources :pay_cashes, :pay_checks, :pay_companies, :pay_vouchers, :pay_credit_cards
    resources :refund_cashes
    resources :order_details
    get :reset_customer, :on => :member
  end
  resources :order_details
  resources :pay_credit_cards, :pay_checks
  resources :emps
  resources :employee_infos do
    resources :employees
    resources :photos do
      get :cover, :on => :member
    end
    resources :accounts
    collection do
      get :docs
      get :shifts
    end
    member do
      get :test_email
      get :edit_info
      get :psw
      post :set_psw
    end
  end
  resources :companies do
    get :add_contact, :on => :collection
    get :search_agent, :on => :collection
    resources :photos do
      get :cover, :on => :member
    end
    resources :accounts 
    get :find_agent, :on => :collection
    get :new_invoice, :on => :member 
  end
  resources :payments do
    get :refund, :on => :collection
  end
  resources :vouchers, :company_receivables
  resources :accounts do
    get :company, :on => :collection
    get :pay, :on => :member
  end
  resources :bills, :invoices
  resources :telephones, :emails, :addresses
  resources :input_types, :tour_types, :positions
  resources :schedule_assignment_costs, :schedule_assignment_balances
  resources :logs
  resources :todos do
    get :zone, :on => :collection
    resource :remarks
    member do
      get :add_employee
      post :add_worker
      delete :rm_worker
    end
  end
  resources :my_logs do
    get :zone, :on => :collection
  end
  resources :app_configurations do
    collection do
      get :reload
    end
  end
  resources :remarks
  resources :cities do
    get :select, :on => :member
    get :get_detail, :on => :member
    get :search, :on => :collection
  end
  resources :auths, :employees

  resources :posts
  resource :test do
    member do
      get :reset_app_session
    end
  end
  resources :messages
	resources :message_receipts
	resources :transfers do
		collection do
			get :to_company
		end
	end
  #match 'home(/:action)', :to => 'home'
  #match 'admin(/:action)', :to => 'admin_tools'
end
