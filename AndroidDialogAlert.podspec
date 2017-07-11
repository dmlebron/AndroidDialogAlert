#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AndroidDialogAlert'
  s.version          = '0.2.1'
  s.summary          = 'This library provides a very simple to use alert very similar to the Android Dialog Alert. Very easy to use and very easy to customize.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This library was created to be the simpleme meant for ease of implementation. Although some customization is provided.'

  s.homepage         = 'https://github.com/davamale/AndroidDialogAlert'
  s.screenshots     = 'https://github.com/davamale/AndroidDialogAlert/blob/master/androidAlert_message.gif', 'https://github.com/davamale/AndroidDialogAlert/blob/master/androidAlert_message_textfield_cancel.gif', 'https://github.com/davamale/AndroidDialogAlert/blob/master/androidAlert_simple.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors           = { 'davamale' => 'david.martinez@unseen.is' }
  s.source           = { :git => 'https://github.com/davamale/AndroidDialogAlert.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Pod/Classes/**/*'

  # s.resource_bundles = {
  #   '${POD_NAME}' => ['${POD_NAME}/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
