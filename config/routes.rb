Rails.application.routes.draw do
  get 'welcome/index'

  # get 'random_ticket'
  # get 'random_ticket/rnd_tix'
  get 'v2/suggestions'
  get 'suggestions/post'
  post 'suggestions/post'
  resources :v2, :widgets, :suggestions, :random_ticket
  root 'welcome#index'
end

