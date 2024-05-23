class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :hpc_memberships
  has_and_belongs_to_many :hpc_groups, through: :hpc_memberships

  def hpc_group_manager?(hg)
    self.is_cesia? || self.hpc_memberships.where(manager: true).any?
  end

  def ldap_create
    ad2gnu = AD2Gnu::Base.new(:personale, Rails.logger).AD_login.local_login
    if (ad_user = ad2gnu.ad.get_user(self.upn))
      Rails.logger.info(ad_user.inspect)
      ad2gnu.local.add_user(ad_user)
    end
  end
end
