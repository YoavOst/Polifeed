# == Schema Information
#
# Table name: politicians
#
#  id                  :integer          not null, primary key
#  full_name           :string(255)
#  fb_page             :string(255)
#  last_refresh_time   :datetime
#  party_id            :integer
#  location_20         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#
# Indexes
#
#  index_politicians_on_party_id  (party_id)
#

class Politician < ActiveRecord::Base
  include FacebookHelper
  belongs_to        :party
  has_many          :statuses
  
  has_attached_file :avatar, 
                    :styles       => {:medium => "200x200>", :thumb => "45x45>"}, 
                    :default_url  => ":style/fi-torso.svg"
  validates_attachment  :avatar,
                        :content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] } 
  
  FB_GET_MAX = 1000

  def total_statuses
    statuses.count
  end
  
  def unprocessed_statuses
    statuses.unprocessed.count
  end
  
  def get_new_statuses
    begin      
      @unixtime = 0 
      @unixtime = last_refresh_time.to_datetime.to_i if !last_refresh_time.nil?
      @new_statsues = FacebookHelper.get_statuses(fb_page, FB_GET_MAX, @unixtime, Time.now.to_i)

      @new_statsues.each do |s|
        @new_status = Status.create(  :fb_status_id => s["id"],
                                      :politician => self,
                                      :publish_time => s["updated_time"],
                                      :fb_get_time => Time.now,
                                      :is_processed => false)
        begin                              
          @new_status.create_status_desc(:desc => s["message"]) 
        rescue
          @new_status.create_status_desc(:desc => "")
        end
      end
      
      update(:last_refresh_time => Time.now)    
        
    rescue => exception
      logger.info exception.class.to_s
      logger.info exception.to_s
      logger.error "Unable to get new statuses for #{self.to_yaml}"
    end      
  end
  
  def set_avatar_from_fb
    begin
      update_attribute(:avatar, URI.parse(FacebookHelper.get_image(fb_page)))
    rescue => exception
      logger.info exception.class.to_s
      logger.info exception.to_s
      logger.error "Unable to get image for #{self.to_yaml}"
    end
  end
  
  def self.fb_initiate(server, port, callback)
    begin
      @url = FacebookHelper.fb_initiate(server, port, callback)
    rescue => exception
      logger.info exception.class.to_s
      logger.info exception.to_s
      logger.error "Unable to create a connection to facebook. Server: #{server}, port: #{port}, callback: #{callback}"
    end
  end
    
end
