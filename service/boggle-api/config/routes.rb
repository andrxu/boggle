Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  scope '/boggle' do
    scope '/v1' do
      scope '/boards' do
        get '/new' => 'boards#new'
        get '/:board' => 'boards#find_word'
        get '/:board/words' => 'boards#solve_board'
      end
    end
  end
end
