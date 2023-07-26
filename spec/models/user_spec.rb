require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'user config created when user is created' do
    let(:user) { create(:user) }

    it { expect(user.config).to be_present }
  end
end
