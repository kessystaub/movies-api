Rails.application.routes.draw do
  resources :movies

  collection do
    post :import_csv
  end
end
