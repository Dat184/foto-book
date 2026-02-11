require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:valid_user) do
      User.new(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123'
      )
    end

    context 'email validation' do
      it 'valid email' do
        expect(valid_user).to be_valid
      end

      it 'without an email' do
        valid_user.email = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:email]).to include("can't be blank")
      end

      it 'blank email' do
        valid_user.email = ''
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:email]).to include("can't be blank")
      end

      it 'duplicate email' do
        user1 = User.create!(
          firstName: 'Jane',
          lastName: 'Smith',
          email: 'test@example.com',
          password: 'password123'
        )
        user2 = User.new(
          firstName: 'John',
          lastName: 'Doe',
          email: 'test@example.com',
          password: 'password456'
        )
        expect(user2).not_to be_valid
        expect(user2.errors[:email]).to include('has already been taken')
      end
    end

    context 'name validation' do
      it 'without a first name' do
        valid_user.firstName = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:firstName]).to include("can't be blank")
      end

      it 'without a last name' do
        valid_user.lastName = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:lastName]).to include("can't be blank")
      end
    end

    context 'password validation' do
      it 'without a password' do
        valid_user.password = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:password]).to include("can't be blank")
      end

      it 'with a short password' do
        valid_user.password = '12345'
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end

      it 'valid password' do
        valid_user.password = '123456'
        expect(valid_user).to be_valid
      end
    end

    context 'role validation' do
      it 'default role' do
        user = User.create!(
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          password: 'password123'
        )
        expect(user.role).to eq('user')
        expect(user.role_user?).to be true
      end

      it 'invalid role with admin' do
        user = User.create!(
          firstName: 'Admin',
          lastName: 'User',
          email: 'admin@example.com',
          password: 'password123',
          role: :admin
        )
        expect(user.role).to eq('admin')
        expect(user.role_admin?).to be true
      end
    end
  end
end
