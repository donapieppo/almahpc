class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :slurm_associations
  has_and_belongs_to_many :slurm_accounts, through: :slurm_associations

  def slurm_account_manager?(sa)
    self.is_cesia? || self.slurm_associations.where(slurm_account: sa, manager: true).any?
  end

  def ldap_create
    Rails.logger.info("ldap_create for upn: #{upn}")
    ad2gnu = User.ad2gnu
    if (ad_user = ad2gnu.ad.get_user(upn))
      Rails.logger.info(ad_user.inspect)
      ad2gnu.local.add_user(ad_user)
    end
  end

  def self.syncronizeDbAndLdap(u_upn)
    if (u = User.syncronize(u_upn))
      u.ldap_create
    end
    u
  end

  # AD2Gnu create base
  def self.ad2gnu
    AD2Gnu::Base.new(:personale, Rails.logger).AD_login.local_login
  end
end
