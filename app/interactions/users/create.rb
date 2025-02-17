# frozen_string_literal: true

module Users
  class Create < ActiveInteraction::Base
    USER_FIELDS = %w[surname name patronymic email age nationality country gender].freeze
    RELATED_MODELS = %w[interests skills].freeze

    # Объявляем входные параметры
    hash :params do
      (USER_FIELDS + RELATED_MODELS).each { |field| string field }
    end

    attr_reader :user

    # Основной функционал в классе Create
    def execute
      return self unless validate # В Readme описал зачем это нужно

      @user = User.new(params.slice(*USER_FIELDS.map(&:to_sym)))

      @user.interests = fetch_interests
      @user.skills = fetch_skills

      errors.merge!(@user.errors) unless @user.save
      self
    end

    # Удобный метод для проверки валидности
    def valid?
      errors.empty?
    end

    private

    # Проверка валидности входных данных
    def validate
      user_not_exist?
      age_valid?
      gender_valid?
      valid?
    end

    # Проверка на существование пользователя с таким email
    def user_not_exist?
      return unless User.where(email: params[:email]).exists?

      errors.add(:email, 'уже существует')
    end

    # Проверка возраста
    def age_valid?
      age = params[:age].to_i
      return if age.positive? && age <= 90

      errors.add(:age, 'должен быть между 1 и 90')
    end

    # Проверка пола
    def gender_valid?
      return if %w[male female].include?(params[:gender]&.strip&.downcase)

      errors.add(:gender, "может быть только 'male' или 'female'")
    end

    # Создание или поиск интересов
    def fetch_interests
      Interest.where(name: params[:interests].split(','))
    end

    # Создание или поиск навыков
    def fetch_skills
      Skill.where(name: params[:skills].split(','))
    end
  end
end
