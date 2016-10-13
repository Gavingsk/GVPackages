#
# Be sure to run `pod lib lint GVPackages.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GVPackages'
  s.version          = '0.0.1'
  s.summary          = 'A collection of commonly used classes and methods in iOS development'
  s.description      = <<-DESC
                        This is a collection of commonly used classes and methods in iOS development
                        DESC
  s.homepage         = 'https://github.com/Gavingsk/GVPackages'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Gavingsk' => 'gavin_gushaokun@126.com' }
  s.source           = { :git => 'https://github.com/Gavingsk/GVPackages.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/*'
end
