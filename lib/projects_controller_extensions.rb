module ProjectsControllerExtensions

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.send(:skip_before_filter, :authorize, only:"membershiprequest")
  end

  module ClassMethods
  end

  module InstanceMethods
    def membershiprequest
      # TODO: role_id 11 is currently hard coded!! (Matthias: ?)
      @project.members << Member.new(:user_id => User.current.id, :role_ids => [ 11 ]) if request.post?
      Mailer.project_membership_request(@project, User.current, params[:description])
    end
  end
end

# todo
# doesn't work in dev env yet. Rails 3 Dispatcher.reload did...
ActionDispatch::Reloader.to_prepare do
  ProjectsController.send(:include, ProjectsControllerExtensions)
end