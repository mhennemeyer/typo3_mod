require File.expand_path('../../test_helper', __FILE__)

class ProjectTest < ActiveSupport::TestCase

  test "header_image_path" do
    # Image exists 
    project = Project.new
    project.stubs(:id).returns(1)
    project.stubs(:has_header_image?).returns(true)
    assert_equal '/headerimages/1.jpg', project.header_image_path
    
    # Image doesn't exist
    project = Project.new
    project.stubs(:id).returns(1)
    project.stubs(:has_header_image?).returns(false)
    assert_equal '', project.header_image_path
  end
  
  test "hierarchy" do
    proj1 = Project.new
    
    proj2 = Project.new
    proj2.stubs(:parent).returns(proj1)
    
    proj3 = Project.new
    proj3.stubs(:parent).returns(proj2)
    
    proj4 = Project.new
    proj4.stubs(:parent).returns(proj3)
    
    assert_equal [proj4, proj3, proj2, proj1], proj4.hierarchy
    
    assert_equal [proj1], proj1.hierarchy
    
  end

end
