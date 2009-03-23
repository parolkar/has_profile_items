class ProfileItem < ActiveRecord::Base
  belongs_to :entity_that_has_profile, :polymorphic => true
end
