Snazzy::Application.routes.draw do
  get "plugin/bar"

  get "bar/index"

  get "user/settings"

  get "session/create"

  get "session/new", as: :new_session

  get "session/destroy"

  get "session/failure"

  get "session/facebook", as: :facebook_signin

  #devise_for :users
  match '/auth/:provider/callback' => 'session#create'

  match '/signin' => 'session#new', :as => :signin

  match '/signout' => 'session#destroy', :as => :signout

  match '/auth/failure' => 'session#failure'

  scope controller: :home do
    get "home" => :index
    get "landing" => :landing
  end

  scope path: '/plugin', controller: :plugin do
    get "bar", as: :bar_plugin
    get "rail", as: :rail_plugin
    get "bar_sign_in"
    get "image_size"
  end

  scope controller: :user do
    get "settings" => :settings
    post "api/recent_room/:id" => :set_recent_room
  end

  #resources :user, :only => [ :show, :edit, :update, :destroy ]

  scope controller: :dressing_rooms do
    get ":username" => :index, as: :dressing_rooms

    scope path: ":username" do
      get ":slug" => :show, as: :dressing_room
      post ":slug/item" => :create_item, as: :create_dressing_room_item
      delete ":slug/:id" => :destroy_item, as: :delete_dressing_room_item
    end
  end

  #get "/user/:username/rooms/:slug" => "dressing_rooms#show", as: :dressing_room
  #post "/user/:username/rooms" => "dressing_rooms#create", as: :create_dressing_room

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (controllers/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
