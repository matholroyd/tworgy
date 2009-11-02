class PostsController < ApplicationController
  make_resourceful do
    actions :all
  end
end
