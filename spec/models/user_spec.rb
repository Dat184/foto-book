require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:valid_user) do
      User.new(
        firtsName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        password: 'password123'
      )
    end

    context 'email validation' do
      it 'is valid with a valid email' do
        expect(valid_user).to be_valid
      end

      it 'is invalid without an email' do
        valid_user.email = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid with a blank email' do
        valid_user.email = ''
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:email]).to include("can't be blank")
      end

      it 'is invalid with a duplicate email' do
        user1 = User.create!(
          firtsName: 'Jane',
          lastName: 'Smith',
          email: 'test@example.com',
          password: 'password123'
        )
        user2 = User.new(
          firtsName: 'John',
          lastName: 'Doe',
          email: 'test@example.com',
          password: 'password456'
        )
        expect(user2).not_to be_valid
        expect(user2.errors[:email]).to include('has already been taken')
      end

      it 'is case insensitive for email uniqueness' do
        user1 = User.create!(
          firtsName: 'Jane',
          lastName: 'Smith',
          email: 'test@example.com',
          password: 'password123'
        )
        user2 = User.new(
          firtsName: 'John',
          lastName: 'Doe',
          email: 'TEST@EXAMPLE.COM',
          password: 'password456'
        )
        expect(user2).not_to be_valid
      end
    end

    context 'name validation' do
      it 'is invalid without a first name' do
        valid_user.firtsName = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:firtsName]).to include("can't be blank")
      end

      it 'is invalid without a last name' do
        valid_user.lastName = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:lastName]).to include("can't be blank")
      end
    end

    context 'password validation' do
      it 'is invalid without a password' do
        valid_user.password = nil
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:password]).to include("can't be blank")
      end

      it 'is invalid with a password that is too short' do
        valid_user.password = '12345'
        expect(valid_user).not_to be_valid
        expect(valid_user.errors[:password]).to include('is too short (minimum is 6 characters)')
      end

      it 'is valid with a password of minimum length' do
        valid_user.password = '123456'
        expect(valid_user).to be_valid
      end
    end

    context 'role validation' do
      it 'has a default role of user' do
        user = User.create!(
          firtsName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          password: 'password123'
        )
        expect(user.role).to eq('user')
        expect(user.role_user?).to be true
      end

      it 'can be set to admin role' do
        user = User.create!(
          firtsName: 'Admin',
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
