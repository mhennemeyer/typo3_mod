Redmine::Plugin.register :typo3_mod do
  name 'Typo3 Mod Plugin'
  author 'Matthias Hennemeyer'
  description 'This is the forge.typo3.org redmine plugin'
  version '0.5.0'
  url 'http://github.com/mhennemeyer/typo3_mod'
  author_url 'http://hypermedialove.com'
end

require File.expand_path('../lib/project_extensions', __FILE__)
require File.expand_path('../lib/projects_controller_extensions', __FILE__)
require File.expand_path('../lib/application_controller_extensions', __FILE__)
require File.expand_path('../lib/base_extensions', __FILE__)
require File.expand_path('../lib/mailer_extensions', __FILE__)


