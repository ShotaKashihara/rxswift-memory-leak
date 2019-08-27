# Uncomment the next line to define a global platform for your project
platform :ios, '12.4'

target 'rxswift-memory-leak' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for rxswift-memory-leak
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'

  target 'rxswift-memory-leakTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
        end
      end
    end
  end
end