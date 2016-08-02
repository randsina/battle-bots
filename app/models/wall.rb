class Wall < ApplicationRecord
  serialize :locations, Hash
end
