module H3d
  class Category < ActiveRecord::Base
    establish_connection :h3d
  end
end
