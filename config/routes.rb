Spree::Core::Engine.routes.draw do
  get '/ideal/accept', :to => 'ideal#success'
  get '/ideal/decline', :to => 'ideal#decline'
  get '/ideal/exception', :to => 'ideal#exception'
  get '/ideal/cancel', :to => 'ideal#cancel'
end
