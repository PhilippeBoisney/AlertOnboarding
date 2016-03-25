Pod::Spec.new do |s|
s.name             = "AlertOnboarding"
s.version          = "1.0"
s.summary          = "AlertOnboarding"
s.description      = "A simple and handsome AlertView for onboard your users in your amazing world."
s.homepage         = "https://github.com/PhilippeBoisney/AlertOnboarding"
s.license          = 'MIT'
s.author           = { "PhilippeBoisney" => "phil.boisney@gmail.com" }
s.source           = { :git => "https://github.com/PhilippeBoisney/AlertOnboarding.git", :tag => s.version.to_s }
s.platform     = :ios, '8.0'
s.requires_arc = true

# If more than one source file: https://guides.cocoapods.org/syntax/podspec.html#source_files
spec.source_files = 'AlertOnboarding/AlertChildPageViewController.swift', 'AlertOnboarding/AlertOnboarding.swift', 'AlertOnboarding/AlertChildPageViewController.xib', 'AlertOnboarding/AlertPageViewController.swift'

end
