target 'CloudHoe' do
    
    pod 'SDWebImage'
    pod 'AFNetworking'
    pod 'SVProgressHUD'
    #pod 'MJRefresh'
    pod 'YYModel'
    #pod 'IQKeyboardManager'
    
    # 集成微信(完整版14.4M)
    #pod 'UMengUShare/Social/WeChat'

    pod 'RongCloudIM/IMLib', '~> 2.8.26'
    pod 'RongCloudIM/IMKit', '~> 2.8.26'

#pod 'GTSDK', '2.1.0.0-noidfa'
    
    pod 'HekrSDK',:subspecs => ['Core', 'socialWeixin'], :podspec => 'https://raw.githubusercontent.com/HEKR-Cloud/HEKR-IOS-SDK/3.4/HekrSDK.podspec'
    pod 'SHAlertViewBlocks'
    pod 'iOS-blur'
    pod 'MBProgressHUD'
    pod 'UMengAnalytics'
    pod 'DYDotsView'
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
            end
        end
    end
    
end
