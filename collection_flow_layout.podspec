#
# Be sure to run `pod lib lint collection_flow_layout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'collection_flow_layout'
  s.version          = '0.1.0'
  s.summary          = 'collection_flow_layout.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/jowkame/collection_flow_layout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jowkame' => 'jowkame@gmail.com' }
  s.source           = { :git => 'https://github.com/jowkame/collection_flow_layout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'collection_flow_layout/Classes/*.swift'
  
  s.subspec 'TagsLayout' do |tags_layout|
    tags_layout.source_files = 'collection_flow_layout/Classes/TagsStyleFlowLayout/*.swift'
  end

  s.subspec 'PinterestLayout' do |pinterest_layout|
    pinterest_layout.source_files = 'collection_flow_layout/Classes/PinterestStyleFlowLayout/*.swift'
  end

  s.subspec 'Px500Layout' do |px500_layout|
    px500_layout.source_files = 'collection_flow_layout/Classes/Px500StyleFlowLayout/*.swift'
  end

end
