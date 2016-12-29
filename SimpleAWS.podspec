#
# Be sure to run `pod lib lint SimpleAWS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SimpleAWS'
  s.version          = '0.1.41'
  s.summary          = 'A CocoaPod for simplifying and beautifying AWS API calls in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'SimpleAWS uses closure chaining to provide a much more readable syntax for AWS calls. Currently only DynamoDB and Cognito are supported, but
                        all AWS modules will be suported eventually.'

  s.homepage         = 'https://github.com/ihanken/SimpleAWS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ihanken' => 'ihanken@bellsouth.net' }
  s.source           = { :git => 'https://github.com/ihanken/SimpleAWS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SimpleAWS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SimpleAWS' => ['SimpleAWS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AWSCore'
  s.dependency 'AWSCognito'
  s.dependency 'AWSCognitoIdentityProvider'
  s.dependency 'AWSDynamoDB'
end
