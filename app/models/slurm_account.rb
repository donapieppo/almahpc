class SlurmAccount < ApplicationRecord
  has_many :slurm_associations
  has_rich_text :description

  validates :slug, format: {with: /\A[a-z]+[a-z0-9_.]+\z/, message: "Only letters,numbers,underscore,_,dot"}

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
