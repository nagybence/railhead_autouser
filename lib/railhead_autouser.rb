module RailheadAutoUserModel

  def self.included(base)
    base.class_eval do
      add_observer(RailheadAutoUserSweeper.instance)
    end
  end
end

module RailheadAutoUserController

  def auto_user
    class_eval do
      cache_sweeper :railhead_auto_user_sweeper
    end
  end
end

class RailheadAutoUserSweeper < ActionController::Caching::Sweeper

  def before_save(record)
    record.user_id = current_user.id if current_user and record.respond_to?(:user_id) and record.new_record? and record.user_id.nil?
  end
end

ActiveRecord::Base.send :include, RailheadAutoUserModel
ActionController::Base.send :extend, RailheadAutoUserController
