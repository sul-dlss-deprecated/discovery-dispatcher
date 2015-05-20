class AboutController < ApplicationController
  
  def index
      render :text=>'ok', :status=>200
  end
  
  def version
    @result = Rails.configuration.targets_url_hash 
    respond_to do |format|
      format.json {render :json=>@result.to_json}
      format.xml {render :json=>@result.to_xml(:root => 'status')}
      format.html {render}
    end            
  end
end
