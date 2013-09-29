Static::Application.routes.draw do

  resources :give, only: [:index, :new, :create]
  
  resources :events do
    resources :payments, only: [:create, :new]
  end

  # the model for credit cards is no longer necessary (we're storing them with
  # stripe), but the routes for credit cards still are
  resources :credit_cards, only: [:new, :create, :delete, :show]

  devise_for :users,
    controllers: { registrations: :registrations, confirmations: :confirmations },
    path: '',
    path_names: {sign_in: 'login',
                 sign_out: 'logout',
                 sign_up: 'register',
                 password: 'reset'}

  devise_scope :user do
    get '/login'                    => 'devise/sessions#new'
    get '/logout'                   => 'devise/sessions#destroy'
    get '/register'                 => 'devise/registrations#new'
    post '/register'                => 'devise/registrations#create'
    get '/reset'                    => 'devise/passwords#new'
    put '/reset'                    => 'devise/passwords#update'
    post '/reset'                   => 'devise/passwords#create'
    get '/reset/change'             => 'devise/passwords#edit'
    get '/account/profile'          => 'devise/registrations#edit'
    patch '/account/profile'        => 'devise/registrations#update'
    put '/account/profile'          => 'devise/registrations#update'
  end

  root to: 'pages#home'
  get '/about'                      => 'pages#about'
    get '/about/biblestudies'       => 'pages#about_biblestudies'
    get '/about/tribes'             => 'pages#about_tribes'
    get '/about/service'            => 'pages#about_service'
    get '/about/socials'            => 'pages#about_socials'
    get '/about/officers'           => 'pages#about_officers'
    get '/about/contact'            => 'pages#about_contact'
  get '/biblestudy'                 => 'pages#biblestudy'
  get '/account'                    => 'pages#account'
  get '/admin'                      => 'pages#admin'
  get '/account/profile'            => 'pages#profile'
  get '/account/preferences'        => 'pages#preferences'
  post '/account/preferences'       => 'pages#update_preferences'
  get '/account/payments'           => 'payments#index'
  get '/privacy_policy'             => 'pages#privacy_policy'
  # TODO: routed with default for expediency, change this later
  get '/admin/contact_all'          => 'contact#contact_all', as: "contact_all"
  post '/admin/send_message'        => 'contact#send_all_message', as: "send_message"
  get '/admin/new_announcement'     => 'contact#new_announcement', as: "new_announcement"
  post '/admin/make_announcement'   => 'contact#make_announcement', as: "make_announcement"
end