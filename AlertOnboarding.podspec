Pod::Spec.new do |s|
s.name             = "AlertOnboarding"
s.version          = "1.13"
s.summary          = "AlertOnboarding"
s.description      = "A simple and handsome AlertView to onboard your users in your amazing world."
s.homepage         = "https://github.com/webdevotion/AlertOnboarding"
s.license          = 'MIT'
s.author           = { "webdevotion" => "webdevotion@gmail.com" }
s.source           = { :git => "https://github.com/webdevotion/AlertOnboarding.git", :tag => s.version }
s.platform     = :ios, '8.0'
s.requires_arc = true

# If more than one source file: https://guides.cocoapods.org/syntax/podspec.html#source_files
s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
  'AlertOnboardingXib' => [
      'Pod/Assets/*.xib'
  ]
}

end
