Rails.application.routes.draw do

  root 'statuses#index'  
  
  get 'stats' => 'statics#stats', as: :stats
  get 'accept_code/*callback' => 'facebook#accept_code', as:  :fb_accept_code
  get 'tags/:tag' => 'statuses#index', as: :tag
  get 'search' => 'searches#new',as: :search
  get 'concordination' => 'words#index', as: :concordination
  get 'admin' => 'politicians#index', as: :admin 

  resources :searches
  resources :cliques  
  resources :phrases
  resources :words
  resources :tags

  resources :statuses do
    resources :words, shallow: true 
    member do
      post 'process_words'
      post 'find_word_abs'
      post 'find_word_sen'
      post 'find_matching_phrase'
    end
    collection do
      get 'process_unprocessed'
#      get 'most_words/:number' => 'statuses#most_words'
    end
  end
  
  resources :politicians do
    resources :statuses, shallow: true 
    member do
      post 'get_new_statuses'
      post 'get_avatar_picture'
    end
    collection do
      get 'get_new_statuses_for_all'
      get 'get_avatar_picture_for_all'
    end
  end 
  
  shallow do
      resources :parties do
        resources :politicians
      end      
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
