require File.expand_path('../../test_helper', __FILE__)

class Typo3LayoutHelperTest < ActiveSupport::TestCase
  include BaseExtensions::InstanceMethods

  test "header_image_style" do
    # Valid Project with color and image
    project = Project.new
    project.stubs({
        id:1,
        has_header_image?:true,
        topbarbackgroundcolor:"#123"
                   })
    assert_equal 'style="background-color:#123;background-image:url(/headerimages/1.jpg);"', header_style(project)
                 

    # Invalid Project
    project = stub({})
    assert_equal ' ', header_style(project)
    
    # Valid Project with color
    project = Project.new
    project.stubs({
        id:1,
        has_header_image?:false,
        topbarbackgroundcolor:"#123"})
    assert_equal ' style="background-color:#123;"', header_style(project)
  end
  
  test "render_header_textcolor" do
    project = Project.new
    project.stubs({topbartextcolor:"#123"})
    assert_equal 'color:#123;', header_textcolor(project)
  end
  
  test "header_menu_html" do
    project = Project.new
    assert header_menu_html(project)
  end
  #
  # test "render_left_menu" do
  #   assert render_left_menu
  # end
end
