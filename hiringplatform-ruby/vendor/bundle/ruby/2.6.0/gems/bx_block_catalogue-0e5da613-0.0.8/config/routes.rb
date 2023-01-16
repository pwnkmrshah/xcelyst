BxBlockCatalogue::Engine.routes.draw do
  resources :catalogues
  resources :tags, only: %i[create index]
  resources :brands, only: %i[create index]
  resources :reviews, only: %i[create index]
  resources :catalogues_variants, only: %i[create index]
  resources :catalogues_variants_colors, only: %i[create index]
  resources :catalogues_variants_sizes, only: %i[create index]
end
