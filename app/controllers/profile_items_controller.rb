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

    render :partial => "/profile_items/edit/#{@profile_item.itemtype.to_s}" , :object => @profile_item
  end

  # POST /profile_items
  # POST /profile_items.xml
  def create
    @profile_item = ProfileItem.new(params[:profile_item])

    respond_to do |format|
      if @profile_item.save
        flash[:notice] = 'ProfileItem was successfully created.'
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
     
    if @profile_item.check(:update_permission,session) == false
      render :text => "Operation Not Permitted / Malicious Request" 
    return 
    end
   
    
    @profile_item.content =  params[:content]
    @profile_item.active = true
      if @profile_item.save
        flash[:notice] = 'ProfileItem was successfully updated.'
        render :partial => "/profile_items/show/#{@profile_item.itemtype.to_s}" , :object => @profile_item
      else
        render :partial => "/profile_items/edit/#{@profile_item.itemtype.to_s}" , :object => @profile_item
      end
    
  end

  
  def destroy
  end
end
