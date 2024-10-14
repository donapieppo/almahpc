# frozen_string_literal: true

class AuthorizedKey::ListComponent < ViewComponent::Base
  def initialize(user)
    @user = user
    @keys = @user.authorized_keys
  end
end
