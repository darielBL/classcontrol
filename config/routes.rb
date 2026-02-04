Rails.application.routes.draw do
  devise_for :users
  root "groups#index"


  resources :groups do
    # Dashboard específico del grupo
    get 'dashboard', to: 'dashboard#show', as: :dashboard

    # Recursos anidados - INCLUYENDO INDEX
    resources :students do
      collection do
        post :import
      end
    end
    resources :class_sessions
    resources :attendance, only: [:index, :create, :update]
  end

  # Otras rutas globales (si las necesitas)
  # resources :students, only: [:index, :show]  # Opcional
  # NO incluyas: resources :class_sessions
end