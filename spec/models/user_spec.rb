require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#opt_enabled?' do
    context 'when default enable is false' do
      let(:user) { create(:user) }

      it { expect(user.otp_enabled?).to be_falsy }
    end

    context 'when enabling one time passwords for user' do
      let(:user) { create(:user) }
      
      before do
        user.config.update!(otp_enabled: true)
      end

      it 'creates active one time password record' do
        expect(user.otp_enabled?).to be_truthy
        expect(user.one_time_passwords.enabled).to be_present
      end
    end

    context 'when disabling one time passwords for user' do
      let(:user) { create(:user) }
      
      before do
        create(:one_time_password, user: user)
      end

      it 'creates active one time password record' do
        expect(user.otp_enabled?).to be_falsy
        expect(user.one_time_passwords.present?).to be_truthy
        expect(user.one_time_passwords.enabled.first).to be_nil

        user.config.update!(otp_enabled: true)

        expect(user.otp_enabled?).to be_truthy
        expect(user.one_time_passwords.enabled.first).not_to be_nil
      end
    end
  end
end
