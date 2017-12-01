source 'https://github.com/CocoaPods/Specs.git'
source 'git@github.com:VibrentHealth/specs-ios.git'

platform :ios, '9.0'

use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

def shared_pods
	pod 'IGListKit', '~> 3.0.0'
	pod 'Kingfisher', '3.7.1'
	pod 'SnapKit', '~> 3.2.0'
	pod 'RxSwift', '~> 3.4'
    pod 'RxCocoa', '~> 3.4'
end

target 'RxSwiftExample' do
  shared_pods
end

target 'RxSwiftExampleTests' do
	shared_pods
end
