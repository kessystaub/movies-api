Rails.application.routes.draw do
  resources :movies do
    collection do
      post :import_csv
    end
  end
end
