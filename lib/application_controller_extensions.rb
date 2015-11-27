module ApplicationControllerExtensions

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
  end

  module InstanceMethods

    #
    # Commented out upper limit 100
    def api_offset_and_limit(options=params)
      if options[:offset].present?
        offset = options[:offset].to_i
        if offset < 0
          offset = 0
        end
      end
      limit = options[:limit].to_i
      if limit < 1
        limit = 25
      # elsif limit > 100
      #   limit = 100
      end
      if offset.nil? && options[:page].present?
        offset = (options[:page].to_i - 1) * limit
        offset = 0 if offset < 0
      end
      offset ||= 0

      [offset, limit]
    end
  end
end

# todo
# doesn't work in dev env yet. Rails 3 Dispatcher.reload did...
ActionDispatch::Reloader.to_prepare do
  ApplicationController.send(:include, ApplicationControllerExtensions)
end

