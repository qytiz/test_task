class User::Create < ActiveInteraction::Base
  hash :params

  EXPECTED_FIELDS = %w[surname name patronymic email age nationality country gender]

  hash :params do
    EXPECTED_FIELDS.each do |field|
      string field
    end
  end

  validate :user_exist?
  validate :age_valid?
  validate :gender_valid?

  def execute
    user_full_name = "#{params['surname']} #{params['name']} #{params['patronymic']}"
    user_params = params.slice(*EXPECTED_FIELDS)
    user = User.create(user_params.merge(full_name: user_full_name))

    user.interests = Interest.where(name: params['interests'].split(','))
    user.skills = Skill.where(name: params['skills'].split(','))

    user.save
  end

  private

  def data_present?
    User.exists?(email: params['email'])
  end

  def age_valid?
    params['age'] > 0 && params['age'] <= 90
  end

  def gender_valid?
    params['gender'] != 'male' && params['gender'] != 'female'
  end
end

