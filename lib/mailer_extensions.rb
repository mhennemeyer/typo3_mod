module MailerExtensions

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
  end

  module ClassMethods
  end

  module InstanceMethods
    def project_membership_request(project, user, description)
      #find all project members with manage_members role
      mail_recipients = Array.new
      project.members.each { |member|
        roles = member.user.roles_for_project(project)
        if roles.any?{|role| role.allowed_to?(:manage_members)}
          mail_recipients << member.user.mail
        end
      }
      #logger.debug('Sending project membership request to '+mail_recipients.join(','))
      body = { :user => user,
           :project => project,
           :url => url_for(:controller => 'projects', :action => 'settings', :id => project.identifier),
           :description => description}

      mail to:mail_recipients, subject:'Request for Membership', body:body, from:user.mail
    end
  end
end

# todo
# doesn't work in dev env yet. Rails 3 Dispatcher.reload did...
ActionDispatch::Reloader.to_prepare do
  Mailer.send(:include, MailerExtensions)
end

