class SlurmAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :slurm_account

  def manager?
    manager
  end
end
