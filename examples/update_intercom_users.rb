#!/usr/bin/env ruby

require 'intercom'
require 'base64'

class Updater

  def initialize

    # noinspection RubyResolve
    Intercom.app_id = ENV['INTERCOM_APP_ID'] || 'default_app_id'
    # noinspection RubyResolve
    Intercom.app_api_key = ENV['INTERCOM_APP_KEY'] || 'default_app_key'

  end

  def read_test_user
    puts 'read_test_user'

    user = Intercom::User.find(:email => 'mail1', :user_id => Base64.encode64('user1').strip)

    p "Reading user #{user.email} from #{# noinspection RubyResolve
      user.location_data.city_name}"

    user
  end

  def run_user_update
    start_time = Time.now

    puts 'Running intercom user updating process'

    p 'Reading all the user from the remote API'

    counter = 0

    puts "Processing #{Intercom::User.count} intercom users"

    Intercom::User.all.each do |user|

      puts %Q(updating user #{counter+=1}: #{user.email})

      begin
        # noinspection RubyResolve
        if Base64.encode64(user.email).strip != user.user_id
          user.user_id = Base64.encode64(user.email).strip
          user.save
          puts 'Saving changes in the API!!!!!!!!!'
        else
          puts 'Correct User_id, nothing updated in the API'
        end
      rescue Intercom::UnexpectedError => e
        if e.http_code[:application_error_code] == 'unique_user_constraint'
          puts "Email duplicated #{user.email}, removing user"
          user.delete
        end
      end
    end

    finish_time = Time.now

    puts "Script executed successfully in #{Time.at((finish_time - start_time)).utc.strftime('%H:%M:%S')} min"
  end
end

updater = Updater.new

updater.run_user_update