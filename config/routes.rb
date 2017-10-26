Rails.application.routes.draw do
  get 'random_ticket/rnd_tix'
  get 'v2/suggestions'
  get 'suggestions/post'
  post 'suggestions/post'
  resources :v2, :widgets, :suggestions
end

