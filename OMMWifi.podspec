
Pod::Spec.new do |s|
s.name             = 'OMMWifi'
s.version          = '1.0'
s.summary          = 'OnMyMobile sdk will help app developers to get more users by promising users a small and relevant incentive. In this version we are giving free WiFi at QFI public WiFi Hotspots when users install the app. For technical integration details or other information please contact kchaitanya@onmymobile.co'
s.homepage         = 'https://github.com/uisolutions-omm/ios-sdk'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Krishna Chaitanya' => 'kchaitanya@onmymobile.co' }
s.source           = { :git => 'https://github.com/uisolutions-omm/ios-sdk.git', :tag => s.version.to_s }
s.ios.deployment_target = '9.0'
s.source_files = 'OMMWifi/Classes/**/*'

# s.resource_bundles = {
#   'OMMWifi' => ['OMMWifi/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'UIKit', 'Foundation', 'Contacts', 'MessageUI', 'SystemConfiguration', 'CoreTelephony', 'Security', 'QuartzCore', 'CoreGraphics'

s.dependency 'CleverTap-iOS-SDK'
s.dependency 'Firebase/Core'
s.dependency 'Firebase/AdMob'
s.dependency 'Firebase/Messaging'
s.dependency 'Firebase/Database'
s.dependency 'Firebase/Invites'
s.dependency 'Firebase/DynamicLinks'
s.dependency 'Firebase/Crash'
s.dependency 'Firebase/RemoteConfig'
s.dependency 'Firebase/Auth'
s.dependency 'Firebase/Storage'
s.dependency 'Firebase/Performance'




end
