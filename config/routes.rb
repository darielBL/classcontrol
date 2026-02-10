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

  # Health check para Koyeb
  get '/up', to: ->(env) do
    # Verifica conexión a base de datos si existe
    ActiveRecord::Base.connection.execute("SELECT 1") if defined?(ActiveRecord)
    [200, { 'Content-Type' => 'text/plain' }, ['OK']]
  rescue => e
    [500, { 'Content-Type' => 'text/plain' }, ["Error: #{e.message}"]]
  end
end