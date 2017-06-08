# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target ‘DBMS’ do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'SQLite.swift', '~> 0.11.2'
  pod 'FMDB'
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
  pod 'ObjectMapper', '~> 2.2'
  pod 'pop', '~> 1.0'
  pod 'RealmSwift'
  pod 'DTAlertViewContainer'
  #pod 'DTAlertViewContainer', :path => '~/Documents/Libraries/DTAlertViewContainer'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end
  
  # Pods for DBMS

  target 'DBMSTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DBMSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
