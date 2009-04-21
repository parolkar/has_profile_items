module ParolkarInnovationLab
  module SocialNet
    def self.included(base)
      base.extend ParolkarInnovationLab::SocialNet::ClassMethods
    end
    
    module ClassMethods
      def has_profile_items items_array,permissions = {}
        include ParolkarInnovationLab::SocialNet::InstanceMethods
        profile_item_types_for_this_model = Array.new
        
        profile_item_permissions_for_this_model = {  #This specifies who can do what.    
          :create_permission => [:itself],
          :update_permission => [:itself],
          :destroy_permission => [:itself]
          
        }   
        
        profile_item_permissions_for_this_model.merge!  permissions
        
              
        #Check validity of these item names as per master configuration list
        items_array.each { |item|
          if PROFILE_ITEM_TYPE.include?(item)
           profile_item_types_for_this_model.push item
          else
            raise "has_profile_items [...:#{item}...] - item type can only be from folowing set [:#{PROFILE_ITEM_TYPE.join(',:')}]"
            
          end
          }
        profile_item_types_for_this_model.freeze # such that no runtime code can modify item types ;-) 
        profile_item_permissions_for_this_model.freeze # such that no runtime code can modify item types ;-)  
        write_inheritable_attribute(:profile_item_types_for_this_model,profile_item_types_for_this_model)
        class_inheritable_reader :profile_item_types_for_this_model
        write_inheritable_attribute(:profile_item_permissions_for_this_model,profile_item_permissions_for_this_model)
        class_inheritable_reader :profile_item_permissions_for_this_model
        
        #profie items
        has_many :profile_items, :as => :entity_that_has_profile
       
      end
    end
    
    module InstanceMethods
      def profile_item_list
        types = profile_item_types_for_this_model
        list =[]
        types.each {|item_type|
          list.push self.profile_items.find_or_create_by_itemtype(item_type.to_s, :conditions => ["active = ?",true], :order => "DESC created_at")
        }
        list   
      end
       def itself
	      self
      end
      def all_in_its_class
        self.class.find :all
      end  
      def profile_items_access_permitted(ar_obj,permission = :update_permission)
         permissions = profile_item_permissions_for_this_model 
         method_symbols = permissions[permission]
         
         permitted_ar_objects = Array.new
         
         method_symbols.each {|method_sym|
           result_obj = ar_obj.send(method_sym.to_sym)
           if result_obj.is_a?(Array)
              permitted_ar_objects = permitted_ar_objects |  result_obj #merge with no duplicates
           else
              permitted_ar_objects << result_obj # single insert
           end
           }
                                                                
         return permitted_ar_objects.include? ar_obj 
      rescue
           false    
      end
      private
        #let private methods come here
    end
  end
end