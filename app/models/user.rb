class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :slurm_associations
  has_and_belongs_to_many :slurm_accounts, through: :slurm_associations

  def slurm_account_manager?(sa)
    self.is_cesia? || self.slurm_associations.where(slurm_account: sa, manager: true).any?
  end

  def ldap_create
    ad2gnu = AD2Gnu::Base.new(:personale, Rails.logger).AD_login.local_login
    if (ad_user = ad2gnu.ad.get_user(self.upn))
      Rails.logger.info(ad_user.inspect)
      ad2gnu.local.add_user(ad_user)
    end
  end
end
