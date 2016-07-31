class Map < ApplicationRecord
  serialize :locations, Hash
end
