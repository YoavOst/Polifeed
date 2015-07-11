module FacebookHelper  
  
  @@oauth = nil
  @@url = nil
  @@graph = nil
  
  def self.fb_initiate(server, port, callback)
      @fb_callback = Rails.application.routes.url_helpers.fb_accept_code_url( :host => server, 
                                                                              :port => port,  
                                                                              :callback => callback)
      @@oauth = Koala::Facebook::OAuth.new( Rails.application.secrets.app_id, 
                                            Rails.application.secrets.app_secret, 
                                            @fb_callback)
      @@url  = @@oauth.url_for_oauth_code(:permissions => ["publish_actions", "public_profile"])
  end
  
  def self.build_graph(code)
    @token = @@oauth.get_access_token(code)
    @@graph = Koala::Facebook::API.new(@token)
  end
  
  def self.get_statuses(page_id, limit, since_time_unix, until_time_unix)
    @statuses = @@graph.get_connections(  page_id.to_s, 
                                          "statuses", 
                                          :fields => ["message"], 
                                          :limit => limit,
                                          :since => since_time_unix,
                                          :until => until_time_unix)   
  end
  
  def self.get_image(page_id)
    @url = @@graph.get_picture(page_id)
  end
end
