# frozen_string_literal: true

class User < ApplicationRecord
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :skills

  validates :surname, :name, :patronymic, :email, :age, :nationality, :country, :gender, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :age, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
  validates :gender, inclusion: { in: %w[male female], message: "должен быть 'male' или 'female'" }

  before_save :downcase_email

  def full_name
    "#{surname} #{name} #{patronymic}"
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
