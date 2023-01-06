BxBlockAdvancedSearch::Engine.routes.draw do
  resource :searchs, only: [] do
    get 'filter'
    get 'sorting'
  end
end
