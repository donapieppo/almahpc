class ApplicationController < DmUniboCommon::ApplicationController
  before_action :set_current_user,
    :update_authorization,
    :set_current_organization,
    :after_current_user_and_organization,
    :log_current_user,
    :set_locale

  # Different from common dm_unibo_common
  def set_current_organization
    if current_user
      @_current_organization = Organization.first
    end
  end

  def set_locale
    I18n.locale = :en
  end
end
