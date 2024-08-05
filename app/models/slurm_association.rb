class SlurmAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :slurm_account

  after_save :syncronizeInLdap

  def manager?
    manager
  end

  def syncronizeInLdap
    ad2gnu = AD2Gnu::Base.new(:personale, Rails.logger).AD_login.local_login
    ldap_user = ad2gnu.local.get_user(user.upn)
    ldap_group = ad2gnu.local.get_group(slurm_account.slug)

    if ldap_user && ldap_group
      Rails.logger.info("syncronizeInLdap: #{ldap_user.inspect}, #{ldap_group.inspect}")
      ad2gnu.local.add_user_to_group(ldap_user, ldap_group)
    end
  end
end
