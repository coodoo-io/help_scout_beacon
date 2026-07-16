#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint help_scout_beacon.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'help_scout_beacon'
  s.version          = '0.2.0'
  s.summary          = 'Help Scout Beacon SDK for Flutter.'
  s.description      = <<-DESC
Streamline customer communications in your app with the Help Scout Beacon SDK for Flutter.
                       DESC
  s.homepage         = 'https://github.com/coodoo-io/help_scout_beacon'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'coodoo GmbH' => 'https://github.com/coodoo-io' }
  s.source           = { :path => '.' }
  # Single source of truth: CocoaPods and Swift Package Manager build the same files.
  s.source_files = 'help_scout_beacon/Sources/help_scout_beacon/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.dependency 'Beacon'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '6.0'
end
