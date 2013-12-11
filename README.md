# DTNumpukViewController

DTNumpukViewController is a View Controller class which has 3 stacked main View Controllers. You will be able to dragging between each of them and interact with each controllers

## Screenshot
![alt tag](https://www.dropbox.com/s/zapd8a61rrcixk4/Foto%2011-12-13%2013.08.13.png)

## Usage

### Create a property on your App Delegate header file

```objective-c
// AppDelegate.h
#import <UIKit/UIKit.h>

@class DTNumpukViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DTNumpukViewController *appController;

@end
```
### Import the file on your App Delegate implementation file

```objective-c
#import "DTNumpukViewController.m"
..
..
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.appController = [[DTNumpukViewController alloc] init];
    
    ViewController *firstView = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    SecondViewController *secondView = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    DataListViewController *dataList = [[DataListViewController alloc] initWithNibName:@"DataListViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:dataList];
    
    [self.appController setFirstViewController:firstView];
    [self.appController setSecondViewController:secondView];
    [self.appController setThirdViewController:navController];
    
    self.window.rootViewController = self.appController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
```

### To open view controller in one of the stacked view

Import AppDelegate and the library

```objective-c
#import "AppDelegate.h"
#import "DTNumpukViewController.h"
```

```objective-c
AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
DTNumpukViewController *numpukView = [appDelegate appController];
    
SomethingViewController *somethingView = [[SomethingViewController alloc] initWithNibName:@"SomethingViewController" bundle:nil];
UINavigationController *somethingNav = [[UINavigationController alloc] initWithRootViewController:somethingView];
    
[numpukView showThirdViewWithViewController:somethingNav];
```

You should see the code what public method available.

## To-do

* Create sample project
* iPad support
* Can't thing anything else.


## How to say thank you

I wrote this code for my own use, and making it available to anyone for the benefit of iOS Developer community. 

You are not encourage to do, but sure I will be glad if you buy one of my apps here. [http://appstore.com/dianagustriadi](http://appstore.com/dianagustriadi)

## Support & Contact

I can't promise to answer any questions regarding this code, but I will try. But I always happy to email telling me that you are using it or just saying thanks.

If you create an app using the code, I'd also want to hear about it. You could find my contact details below:

Portfolio site [http://didatstriadi.com](http://didatstriadi.com)  
Twitter site [https://twitter.com/didats](https://twitter.com/didats)

## License and Warranty

The license for the code is basically a BSD license with attribution.

You're welcome to use it in commercial, closed-source, open source, free or any other kind of software, as long as you credit me appropriately.

The DTNumpukViewController code comes with no warranty of any kind, no guarantees regarding its functionality or otherwise. I hope it will be useful to you.
