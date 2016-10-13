# GVPackages

[![CI Status](http://img.shields.io/travis/Gavingsk/GVPackages.svg?style=flat)](https://travis-ci.org/Gavingsk/GVPackages)
[![Version](https://img.shields.io/cocoapods/v/GVPackages.svg?style=flat)](http://cocoapods.org/pods/GVPackages)
[![License](https://img.shields.io/cocoapods/l/GVPackages.svg?style=flat)](http://cocoapods.org/pods/GVPackages)
[![Platform](https://img.shields.io/cocoapods/p/GVPackages.svg?style=flat)](http://cocoapods.org/pods/GVPackages)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```Objective-C
    UIView *newView.cornerRadius = [UIView viewWithColor:[UIColor yellowColor] size:CGSizeZero];
    //直接更改view的坐标
    newView.width = 100;
    newView.x = 100;
    newView.y = 100;
    newView.height = 100;
    newView.cornerRadius = 5;
    //支持16进制颜色
    UIColor *hexColor = [UIColor colorFromHexRGB:@"48AD32"];
    newView.backgroundColor = hexColor;
    [self.view addSubview:newView];

    //这一句
    __unsafe_unretained GVViewController *__weakSelf = self;
    //等价于
    GVWeekRef(self);
    // __weakSelf == __self;

    void(^block1)() = ^{

    [__weakSelf view];
    [__self view];

    };

    block1();

    UIWindow *window = __self.view.window;
    UIWindow *keyWindow = GVKeyWindow;
    NSString *str = [NSString stringWithFormat:@"%@%@%@",@"a",@"b",@"c",@"d"];
    NSString *newStr = GVString(@"%@%@%@",@"a",@"b");
    NSLog(@"%@",str);
    GVLog(@"%@",newStr); //在Release模式 不打印
```

## Requirements

## Installation

GVPackages is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "GVPackages"
```

## Author

Gavingsk, gavin_gushaokun@126.com

## License

GVPackages is available under the MIT license. See the LICENSE file for more info.
