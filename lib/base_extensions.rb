module BaseExtensions
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    include ActionView::Helpers::UrlHelper

    def quicklinks(project)
      project ? textilizable(project.quicklinks) :''
    end

    def header_style(project)
      html_attribute_with_value('style',
        css_attribute(
          'background-color', project.try(:topbarbackgroundcolor)
        ) + 
        css_attribute(
          'background-image', css_url(project.try(:header_image_path))
        )
      ).html_safe
    end

    def header_textcolor(project)
      css_attribute('color', project.try(:topbartextcolor))
    end

    def header_menu_html(project)
      # Link to Start page
      start_link = link_to "Start", "/", class:"start#{project ? '' : ' current'}"

      # Links to Toplevel Projects
      root_identifier = project ? get_parent_project_identifiers(project).last : 'start'
      top_links = Project.top_level.map do |prj|
        generate_link_to_project(prj, (root_identifier == prj.identifier), 0)
      end

      ([start_link] << top_links).join("").html_safe
    end

    # todo
    # refactor. Espacially 'outputProjectsRecursively' :)
    def left_menu_html (project)
      out = ''     
      if project and !project.try(:new_record?)
        @projectidentifier = project.identifier
        rootline = get_parent_project_identifiers(project)
        top_level_project = Project.find(rootline.last)
        out += outputProjectsRecursively(top_level_project, rootline, 1)
      end
      
      out.html_safe
    end

    # todo sso - user image from typo3.org
    # Display a link to user's account page with IMAGE
    def link_to_user_with_image(user, size=0)
      if user
        completeLink = output_user_image user, size
        completeLink << link_to(user, :controller => 'users', :action => 'show', :id => user)
        if size == 1
          completeLink << " (#{user.login})"
        end
        completeLink.html_safe  # return it
      else
        'Anonymous'
      end
    end

    # output the user image
    def output_user_image(user, size=0)
      imageSize = case size
                    when 0 then "small"
                    when 1 then "mid"
                    when 2 then "big"
                  end
      if ! (user.img_hash.nil? || user.img_hash=='')
        imageFile = user.img_hash
      else
        imageFile = '_dummy'
      end
      userimage = "//typo3.org/fileadmin/userimages/#{imageFile}-#{imageSize}.jpg"
      "<img src='#{userimage}' class='userimage userimage-#{size}' />".html_safe
    end

    # format a mail link to current user. only shown if a user is currently logged in
    def format_mail(user)
      if User.current.logged?
        mail_to user.mail unless user.pref.hide_mail
      else
        "***@***.***"
      end
    end
    
    private
    
    def valid_value?(value)
      value.is_a?(String) && !value.empty?
    end

    def html_attribute_with_value(name="", value=false)
      valid_value?(value) ? "#{name}=#{value}" : ""
    end

    def css_attribute(name="", value=false)
      valid_value?(value) ? "#{name}:#{value};" : ""
    end
    
    def css_url(value)
      valid_value?(value) ? "url(#{value})" : ""
    end
    
    def get_parent_project_identifiers (project)
      project.hierarchy.map(&:identifier)
    end

    def generate_link_to_project (project, active, level)
      htmlOptions = {
          :class => "level-#{level} sorting-#{project.sorting}"
      }
      
      htmlOptions[:class] += ' current' if active

      return link_to project.name, {:controller => 'projects', :action => 'show', :id => project.identifier }, htmlOptions
    end

    def outputProjectsRecursively (project, rootline, level, inSelectTag = false)
      out = ''

      projects = Project.visible_children(project, User.current)

      if (inSelectTag || ( level == 2 && projects.length > 20 ) ) then
        if (level == 2) then
          out += '<select onchange="window.location.href=\'/projects/\'+this.value"><option value="extensions">- Select Subproject-</option>'
        end
        projects.each do |prj|
          select = ''
          if (prj.identifier == @projectidentifier) then
            select = 'selected="selected"'
          end
          out += '<option '+select+' value="'+prj.identifier+'">'+prj.name+'</option>'
          out += outputProjectsRecursively(prj, rootline, level+1, true)
        end

        if (level == 2) then
          out += '</select>'
        end
      else
        projects.each { |prj|
          if (rootline.include? prj.identifier) then # Selected menu item
            out += generate_link_to_project(prj, true, level)
            out += outputProjectsRecursively(prj, rootline, level + 1)
          else # Not selected menu item
            out += generate_link_to_project(prj, false, level)
          end
        }
      end
      out
    end
  end
end

# todo
# doesn't work in dev env yet. Rails 3 Dispatcher.reload did...
ActionDispatch::Reloader.to_prepare do
  ActionView::Base.send(:include, BaseExtensions)
end
