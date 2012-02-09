Rails.application.routes.draw do
  
  # Keep these above the articles resources block
  match "articles/review/" => 'articles#review', :as => :review_articles
  match "articles/feature/" => 'articles#feature', :as => :feature_articles
  match "articles/page/:page" => "articles#index"
  match "articles/tagged/:tag" => 'articles#tagged', :as => :tagged_articles
    
  resources :articles do
    resources :comments, :only => [:create, :destroy]
  end

  root :to => "articles#index"
end
