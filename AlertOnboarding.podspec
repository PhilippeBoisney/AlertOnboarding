Pod::Spec.new do |s|
s.name             = "AlertOnboarding"
s.version          = "2.4"
s.summary          = "AlertOnboarding"
s.description      = "A simple and handsome AlertView for onboard your users in your amazing world."
s.homepage         = "https://github.com/doronkatz/AlertOnboarding"
s.license          = 'MIT'
s.author           = { "doronkatz" => "doron@doronkatz.com" }
s.source           = { :git => "https://github.com/doronkatz/AlertOnboarding.git", :tag => s.version }
s.platform     = :ios, '12.1'
s.requires_arc = true

# If more than one source file: https://guides.cocoapods.org/syntax/podspec.html#source_files
s.source_files = 'Pod/Classes/**/*'
s.resource_bundles = {
  'AlertOnboardingXib' => [
      'Pod/Assets/*.xib'
  ]
}

end
