install! 'cocoapods', integrate_targets: false, share_schemes_for_development_pods: true, :disable_input_output_paths => true

platform :ios, '10.0'

use_modular_headers!
inhibit_all_warnings!

target 'Demos' do
	pod 'PinIt'
	pod 'Nuke', :podspec => 'Nuke.podspec'
	pod 'ALLKit', :path => './', :appspecs => ['Demos'], :testspecs => ['Tests']

	target 'DemosTests' do
		inherit! :search_paths
	end
end
