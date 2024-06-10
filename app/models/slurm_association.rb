class SlurmAssociation < ApplicationRecord
  belongs_to :user
  belongs_to :slurm_account
end
