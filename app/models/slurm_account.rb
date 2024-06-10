class SlurmAccount < ApplicationRecord
  has_many :slurm_associations
  has_rich_text :description

  def to_s
    name
  end
end
