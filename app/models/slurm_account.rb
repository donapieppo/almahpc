class SlurmAccount < ApplicationRecord
  has_many :slurm_associations
  has_rich_text :description

  validates :slug, format: {with: /\A[a-z]+[a-z0-9_.]+\z/, message: "Only letters,numbers,underscore,_,dot"}

  after_save :syncronizeInLdap

  def to_s
    name
  end

  def syncronizeInLdap
    ad2gnu = AD2Gnu::Base.new(:personale, Rails.logger).AD_login.local_login
    g = AD2Gnu::LocalGroup.new(slug, name)

    if ad2gnu.local.get_group(slug) # if exists
      ad2gnu.local.update_group(g)
    else # if to create
      ad2gnu.local.add_group(g)
    end
  end
end
