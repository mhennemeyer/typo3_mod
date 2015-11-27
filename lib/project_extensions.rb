module ProjectExtensions
  
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
    base.send(:extend, ClassMethods)
    base.send(:after_save, :move_header_image_file_to_public_folder)
  end
  
  module ClassMethods

    def top_level
      where('parent_id IS NULL').order(sorting: :desc)
    end

    def visible_children(project, user)
      order("sorting, name").
          where(Project.visible_condition(user)).
          where("parent_id = ?", project.id)
    end

  end

  module InstanceMethods

    def topbarheaderimage=(file_data)
      @file_data = file_data
    end

    def has_header_image?
      FileTest.exists?(header_image_url)
    end

    def header_image_path
      has_header_image? ? header_image_local_path_name : ""
    end
    
    def hierarchy
      parents_hierarchy([self])
    end
    
    private

    def parents_hierarchy(arr)
      (p=arr.last.parent) ? parents_hierarchy(arr << p) : arr
    end

    # after_save callback
    def move_header_image_file_to_public_folder
      if @file_data.try(:respond_to?, 'original_filename')
        path = header_image_url
        unless File.exist?(path)
          Dir.mkdir(path)
        end
        File.open(header_image_url, "wb") { |file| file.write(@file_data.read) }
      end
    end

    def header_image_url
      "#{Rails.root}/public#{header_image_local_path_name}"
    end
    
    def header_image_local_path_name
      "/#{header_images_folder_name}/#{id}.jpg"
    end

    def header_images_folder_name
      "headerimages"
    end

  end
end

# todo
# doesn't work in dev env yet. Rails 3 Dispatcher.reload did...
ActionDispatch::Reloader.to_prepare do
  Project.send(:include, ProjectExtensions)
  Project.safe_attributes 'topbarbackgroundcolor', 'topbartextcolor', 'topbarheaderimage', 'quicklinks'
end