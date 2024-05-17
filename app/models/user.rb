class User < ApplicationRecord
  include DmUniboCommon::User
  has_many :hpc_memberships
  has_and_belongs_to_many :hpc_groups, through: :hpc_memberships

  def hpc_group_manager?(hg)
    self.is_cesia? || self.hpc_memberships.where(manager: true).any?
  end
end
