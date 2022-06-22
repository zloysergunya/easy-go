platform :ios, '13.0'

target 'SFUHackathon2021' do
  use_frameworks! :linkage => :static
  inhibit_all_warnings!
  
  # Interface
  pod 'IQKeyboardManagerSwift'
  pod 'OverlayContainer'
  pod 'IGListKit', '~> 4.0'
  pod 'PinLayout', '~> 1.8'
  pod 'SnapKit', '~> 5.0.0'
  pod 'Atributika', '~> 4.9.0'
  pod 'Kingfisher'
  
  # Utilities
  pod 'R.swift', '~> 5.4.0'
  pod 'SwiftyBeaver'

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
  end
 end
end
