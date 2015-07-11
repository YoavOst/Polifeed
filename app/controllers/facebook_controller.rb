class FacebookController < ApplicationController
  helper :Facebook
  
  def accept_code
    @g = FacebookHelper.build_graph(params[:code])
    if @g
      puts params[:code]
      redirect_to '/' + params[:callback]
    else
      render :file => 'public/404.html', :status => :not_found, :layout => false
    end
  end
    
end
