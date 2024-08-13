class SlurmAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :slurm_account

  after_save :syncronize_in_ldap

  def manager?
    manager
  end

  def syncronize_in_ldap
    ad2gnu = User.ad2gnu
    ldap_user = ad2gnu.local.get_user(user.upn)
    ldap_group = ad2gnu.local.get_group(slurm_account.slug)

    if ldap_user && ldap_group
      Rails.logger.info("syncronize_in_ldap: #{ldap_user.inspect}, #{ldap_group.inspect}")
      ad2gnu.local.add_user_to_group(ldap_user, ldap_group)
    end
  end
end
