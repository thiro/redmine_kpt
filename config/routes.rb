resources :projects do
  resources :kpt, :controller => 'kpt_boards', :only => [:index, :create, :show, :edit, :update, :destroy] do
    resources :entries, :controller => 'kpt_entries', :only => [:index, :create, :destroy]
    # lock/unlock
    get    :lock, :to => 'kpt_boards#locked?', :as => :lock
    post   :lock, :to => 'kpt_boards#lock'
    delete :lock, :to => 'kpt_boards#unlock'
  end
end
