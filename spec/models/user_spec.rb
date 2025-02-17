require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) } 

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:interests) }
    it { is_expected.to have_and_belong_to_many(:skills) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:surname) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:patronymic) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:nationality) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:gender) }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it do
      is_expected.to validate_numericality_of(:age).
        only_integer.
        is_greater_than(0).
        is_less_than(100)
    end

    it do
      is_expected.to validate_inclusion_of(:gender).
        in_array(%w[male female]).
        with_message("должен быть 'male' или 'female'")
    end
  end

  describe '#full_name' do
    it 'возвращает полное имя, составленное из surname, name и patronymic' do
      user = build(:user, surname: 'Иванов', name: 'Иван', patronymic: 'Иванович')
      expect(user.full_name).to eq('Иванов Иван Иванович')
    end
  end
end