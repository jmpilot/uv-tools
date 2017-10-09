Rails.application.routes.draw do
  get 'random_ticket/rnd_tix'
  get 'v2/suggestions'
  resources :v2, :widgets
end

