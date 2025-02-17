class Users::Create < ActiveInteraction::Base
  hash :params

  USER_FIELDS = %w[surname name patronymic email age nationality country gender]
  RELATED_MODELS = %w[interests skills]

  hash :params do
    (USER_FIELDS+RELATED_MODELS).each do |field|
      string field
    end
  end

  validate :user_exist?
  validate :age_valid?
  validate :gender_valid?

  def execute
    user_params = params.slice(*USER_FIELDS.map(&:to_sym))
    user = User.create(user_params)

    user.interests = Interest.where(name: params[:interests].split(','))
    user.skills = Skill.where(name: params[:skills].split(','))

    user.save
  end

  private

  def user_exist?
    User.exists?(email: params[:email])
  end

  def age_valid?
    params[:age].to_i > 0 && params[:age].to_i < 100
  end

  def gender_valid?
    params[:gender] != 'male' && params[:gender] != 'female'
  end
end

