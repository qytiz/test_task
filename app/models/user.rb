class User < ApplicationRecord
  has_many :interests
  has_many :skills, class_name: 'skill'
end
