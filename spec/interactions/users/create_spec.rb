# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:valid_params) do
    {
      surname: 'Иванов',
      name: 'Иван',
      patronymic: 'Иванович',
      email: 'ivanov@example.com',
      age: '25',
      nationality: 'Русский',
      country: 'Россия',
      gender: 'male',
      interests: 'спорт,музыка',
      skills: 'рукоделие,коммуникации'
    }
  end

  describe '#execute' do
    context 'when params are valid' do
      it 'creates a new user' do
        result = described_class.run(params: valid_params)
        expect(result.valid?).to be true
        expect(User.find_by(email: 'ivanov@example.com')).not_to be_nil
      end

      it 'accepts age at the lower boundary (1)' do
        params = valid_params.merge(age: '1')
        result = described_class.run(params: params)
        expect(result.valid?).to be true
        expect(User.find_by(email: 'ivanov@example.com').age).to eq(1)
      end

      it 'accepts age at the upper boundary (90)' do
        params = valid_params.merge(age: '90')
        result = described_class.run(params: params)
        expect(result.valid?).to be true
        expect(User.find_by(email: 'ivanov@example.com').age).to eq(90)
      end
    end

    context 'when email already exists' do
      it 'returns an error' do
        create(:user, email: 'ivanov@example.com')
        result = described_class.run(params: valid_params)
        expect(result.valid?).to be false
        expect(result.errors[:email]).to include('уже существует')
      end
    end

    context 'when age is invalid' do
      it 'returns an error for negative age' do
        invalid_params = valid_params.merge(age: '-5')
        result = described_class.run(params: invalid_params)
        expect(result.valid?).to be false
        expect(result.errors[:age]).to include('должен быть между 1 и 90')
      end

      it 'returns an error for age 0' do
        invalid_params = valid_params.merge(age: '0')
        result = described_class.run(params: invalid_params)
        expect(result.valid?).to be false
        expect(result.errors[:age]).to include('должен быть между 1 и 90')
      end

      it 'returns an error for age > 90' do
        invalid_params = valid_params.merge(age: '91')
        result = described_class.run(params: invalid_params)
        expect(result.valid?).to be false
        expect(result.errors[:age]).to include('должен быть между 1 и 90')
      end
    end

    context 'when gender is invalid' do
      it 'returns an error for incorrect gender' do
        invalid_params = valid_params.merge(gender: 'unknown')
        result = described_class.run(params: invalid_params)
        expect(result.valid?).to be false
        expect(result.errors[:gender]).to include("может быть только 'male' или 'female'")
      end

      it 'returns an error for blank gender' do
        invalid_params = valid_params.merge(gender: '   ')
        result = described_class.run(params: invalid_params)
        expect(result.valid?).to be false
        expect(result.errors[:gender]).to include("может быть только 'male' или 'female'")
      end
    end

    context 'when interests and skills are assigned' do
      before do
        create(:interest, name: 'спорт')
        create(:interest, name: 'музыка')
        create(:skill, name: 'рукоделие')
        create(:skill, name: 'коммуникации')
      end

      it 'assigns the correct interests and skills' do
        described_class.run(params: valid_params)
        user = User.find_by(email: 'ivanov@example.com')
        interest_names = user.interests.pluck(:name)
        skill_names = user.skills.pluck(:name)
        expect(interest_names).to include('спорт', 'музыка')
        expect(skill_names).to include('рукоделие', 'коммуникации')
      end
    end
  end
end
