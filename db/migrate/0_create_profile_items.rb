class CreateProfileItems < ActiveRecord::Migration
  def self.up
    create_table :profile_items do |t|
      t.string :itemtype # Go look at [plugin_dir]/config/initializers/profile_items.rb
      t.text :content
      t.boolean :active ,  :default => true 
      t.integer :entity_that_has_profile_id # Essentially , it is entity_that_has_profile's id
      t.string :entity_that_has_profile_type # Essentially , it is entity_that_has_profile's type    
      t.string :icon
      t.string :file_attached
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_items
  end
end
