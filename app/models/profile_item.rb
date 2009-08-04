class ProfileItem < ActiveRecord::Base
  belongs_to :entity_that_has_profile, :polymorphic => true    
  attr_writer :profile_item_options # this is an temporary Hash to hold references to temporary Objects that are supposed to be used by views
    
  def profile_item_options ; @profile_item_options  ||= Hash.new ;  end
    
  file_column :icon, :magick => { 
            :versions => { "thumb" => "30x30", "medium" => "90x90","large" => "640x480" }
          }
  
  file_column :file_attached
  
  def check(permission, app_session)  
      ar_obj = ProfileItem.get_obj_accessing(app_session) 
      return self.entity_that_has_profile.profile_items_access_permitted(ar_obj,permission)
  rescue
      false  
  end    
  
  
  def self.obj_accessing_profile_items(ar_obj,app_session)
     app_session[:obj_accessing_profile_items_id] = ar_obj.id 
     app_session[:obj_accessing_profile_items_type] = ar_obj.class
  end 
  def self.get_obj_accessing(app_session)
     ar_obj = Object.new
    
     if app_session.has_key?(:obj_accessing_profile_items_type)      &&      app_session.has_key?(:obj_accessing_profile_items_id)
         ar_type =  app_session[:obj_accessing_profile_items_type].to_s
         ar_id =  app_session[:obj_accessing_profile_items_id].to_i
         ar_obj = ar_type.constantize.find(ar_id)
        
     end 
     return ar_obj  
   
  end   
end
