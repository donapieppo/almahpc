# In ldap e' il gruppo
# in Slurmdbd e' l'account 
# A description of the account and the organization to which it belongs must be specified.
# These terms can be used later to generate accounting reports
class SlurmAccount < ApplicationRecord
  has_many :slurm_associations
  has_rich_text :description

  validates :slug, format: {with: /\A[a-z]+[a-z0-9_.]+\z/, message: "Only letters, numbers and _"}
  validates :slug, length: {maximum: 25}

  after_save :syncronize_in_ldap

  def to_s
    name
  end

  def syncronize_in_ldap
    g = AD2Gnu::LocalGroup.new(slug, name)

    ad2gnu = User.ad2gnu
    if ad2gnu.local.get_group(slug) # if exists
      ad2gnu.local.update_group(g)
    else # if to create
      ad2gnu.local.add_group(g)
    end
  end
end
