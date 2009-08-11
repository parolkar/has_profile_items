class ProfileItemsController < ApplicationController
 
 
  def show
    @profile_item = ProfileItem.find(params[:id])
    #TODO : Security check required
    render :partial => "/profile_items/show/#{@profile_item.itemtype.to_s}" , :object => @profile_item
  end

  # GET /profile_items/edit/1
  def edit
    #TODO : Security check required
    @profile_item = ProfileItem.find(params[:id])
    
    if @profile_item.check(:update_permission,session) == true # Check if accessing obj has edit permission   
       render :partial => "/profile_items/edit/#{@profile_item.itemtype.to_s}" , :object => @profile_item
    else
       render :partial => "/profile_items/show/#{@profile_item.itemtype.to_s}" , :object => @profile_item 
    end
  end

  # POST /profile_items
  # POST /profile_items.xml
  def create
    @profile_item = ProfileItem.new(params[:profile_item])

    if params.has_key?(:attachments)
        @profile_item.icon =  params[:attachments][:icon] 
        @profile_item.icon_temp =  params[:attachments][:icon_temp]
    end    

    respond_to do |format|
      if @profile_item.save
        #flash[:notice] = 'ProfileItem was successfully created.'
        format.html { redirect_to(@profile_item) }
        format.xml  { render :xml => @profile_item, :status => :created, :location => @profile_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update
    @profile_item = ProfileItem.find(params[:id])
     
    if @profile_item.check(:update_permission,session) != true
      render :text => "Operation Not Permitted / Malicious Request" 
    return 
    end
   
    if params.has_key?(:attachments)       
        @profile_item.icon =  params[:attachments][:icon] 
        @profile_item.icon_temp =  params[:attachments][:icon_temp]
    end 
    @profile_item.content =  params[:content]
    @profile_item.active = true
      if @profile_item.save
        #flash[:notice] = 'ProfileItem was successfully updated.'
        render :partial => "/profile_items/show/#{@profile_item.itemtype.to_s}" , :object => @profile_item
      else
        render :partial => "/profile_items/edit/#{@profile_item.itemtype.to_s}" , :object => @profile_item
      end
    
  end

  
  def destroy
  end 
  
  def edit_attachment
     @profile_item =   ProfileItem.find(params[:profile_item_id])  
     if @profile_item.check(:update_permission,session) != true
       render :text => "Operation Not Permitted / Malicious Request" 
     return 
     end
     
     @update_column = params[:update_column]
     render :layout => false
        
     
    
  end   
  
  def update_attachment   
      @profile_item =   ProfileItem.find(params[:profile_item_id])  
      if @profile_item.check(:update_permission,session) != true
        render :text => "Operation Not Permitted / Malicious Request" 
      return 
      end 
       @attachment_type = ""
       if params.has_key?(:attachments)  
            if params[:attachments].has_key?(:icon)  
              @profile_item.icon =  params[:attachments][:icon] 
              @profile_item.icon_temp =  params[:attachments][:icon_temp]  
              @attachment_type = "icon"  
            elsif params[:attachments].has_key?(:file_attached)  
              @profile_item.file_attached =  params[:attachments][:file_attached] 
              @profile_item.file_attached_temp =  params[:attachments][:file_attached_temp]
              @attachment_type = "file_attached"  
            end 
              
       end  
       
       @profile_item.content = " " if @profile_item.content == nil            # a small hack    
       
       if @profile_item.save
         #flash[:notice] = 'ProfileItem was successfully updated.'
         #render :partial => "/profile_items/show/#{params[:column]}_column" , :locals=>{ :profile_item => @profile_item , :column => params[:column]}
         render :action => "show_attachment" , :layout => false
       else
         render :text => "Something went wrong :-( (either the file is invalid or huge in size) <a href=\"/profile_items/edit_attachment?profile_item_id=#{@profile_item.id.to_s}&update_column=#{@attachment_type}\" ><b>retry</b></a>" 
       end
       
      
    
  end
  
end
