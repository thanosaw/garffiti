# gARffiti
AR 3d drawing app in ARKit using metal + SceneKit.

Code adapted from:
  https://github.com/laanlabs/ARBrush

## Author

This project was created by Java City for LA Hacks 2023.

## Firebase setup

In the main directory do `pod init` to create the Podfile. Use a text editing method of your choice to input the following lines into the Podfile:

```
target 'ARBrush' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ARBrush
pod 'Appirater'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Analytics'
pod 'Firebase/Crashlytics'
pod 'Firebase/Storage'

end
```

Save the file and in the main directory do `pod install` to install the dependencies. 
