class Users::Create < ActiveInteraction::Base
  USER_FIELDS = %w[surname name patronymic email age nationality country gender]
  RELATED_MODELS = %w[interests skills]

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

    if @user.save
      self
    else
      errors.merge!(@user.errors)
      self
    end
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
    if User.where(email: params[:email]).exists?
      errors.add(:email, 'уже существует')
    end
  end

  # Проверка возраста
  def age_valid?
    age = params[:age].to_i
    unless age.positive? && age <= 90
      errors.add(:age, 'должен быть между 1 и 90')
    end
  end

  # Проверка пола
  def gender_valid?
    unless %w[male female].include?(params[:gender]&.strip&.downcase)
      errors.add(:gender, "может быть только 'male' или 'female'")
    end
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