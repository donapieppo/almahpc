class AuthorizedKey < ApplicationRecord
  belongs_to :user

  after_save :ldap_sync
  after_destroy :ldap_sync

  def ldap_sync
    ad2gnu_local = AD2Gnu::Base.new.local_login.local
    user_dn = ad2gnu_local.get_dn_from_uidNumber(self.user.id)
    ad2gnu_local.conn.modify(dn: user_dn, operations: [[:replace, :sshPublicKey, self.user.authorized_keys.map(&:name)]])
  end
end
