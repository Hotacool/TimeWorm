//
//  TWHelp.h
//  TimeWorm
//
//  Created by macbook on 16/8/30.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#ifndef TWHelp_h
#define TWHelp_h
// UI控件常规像素
#define APPCONFIG_UI_TABLE_CELL_HEIGHT      44.0f                       // UITableView 单元格默认高度
#define APPCONFIG_UI_TIPS_SHOW_SECONDS      2.0f                        // 自动隐藏的弹窗，显示的时间（单位秒）
#define APPCONFIG_UI_STATUSBAR_HEIGHT       20.0f                       // 系统自带的状态条的高度
#define APPCONFIG_UI_NAVIGATIONBAR_HEIGHT   44.0f                       // 系统自带的导航条的高度
#define APPCONFIG_UI_TOOLBAR_HEIGHT         44.0f                       // 系统自带的工具条的高度
#define APPCONFIG_UI_TABBAR_HEIGHT          49.0f                       // 系统自带分页条的高度
#define APPCONFIG_UI_SEARCHBAR_HEIGHT       44.0f                       // 系统自带的搜索框的高度

//常用路径
#define APPCONFIG_PATH_DOCUMENT [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]   //document目录

/** 色值 RGBA **/
#define RGB_A(r, g, b, a) [UIColor colorWithRed:(CGFloat)(r)/255.0f green:(CGFloat)(g)/255.0f blue:(CGFloat)(b)/255.0f alpha:(CGFloat)(a)]

/** 色值 RGB **/
#define RGB(r, g, b) RGB_A(r, g, b, 1)
#define RGB_HEX(__h__) RGB((__h__ >> 16) & 0xFF, (__h__ >> 8) & 0xFF, __h__ & 0xFF)
/** 默认色值 **/
#define WPink RGB(250, 150, 194)
#define WPurple RGB(220, 197, 250)
#define WBlue RGB(100, 190, 250)
#define LBlue RGB(175, 235, 230)

#define Hgrapefruit   RGB_HEX(0xED5565)
#define HgrapefruitD  RGB_HEX(0xDA4453)
#define Hbittersweet  RGB_HEX(0xFC6E51)
#define HbittersweetD RGB_HEX(0xE9573F)
#define Hsunflower    RGB_HEX(0xFFCE54)
#define HsunflowerD   RGB_HEX(0xF6BB42)
#define Hgrass        RGB_HEX(0xA0D468)
#define HgrassD       RGB_HEX(0x8CC152)
#define Hmint         RGB_HEX(0x48CFAD)
#define HmintD        RGB_HEX(0x37BC98)
#define Haqua         RGB_HEX(0x4FC1E9)
#define HaquaD        RGB_HEX(0x3BAFDA)
#define Hbluejeans    RGB_HEX(0x5D9CEC)
#define HbluejeansD   RGB_HEX(0x4A89DC)
#define Hlavander     RGB_HEX(0xAC92EC)
#define HlavanderD    RGB_HEX(0x967ADC)
#define Hpinkrose     RGB_HEX(0xEC87C0)
#define HpinkroseD    RGB_HEX(0xD770AD)
#define Hlightgray    RGB_HEX(0xF5F7FA)
#define HlightgrayD   RGB_HEX(0xE6E9ED)
#define Hmediumgray   RGB_HEX(0xCCD1D9)
#define HmediumgrayD  RGB_HEX(0xAAB2BD)
#define Hdarkgray     RGB_HEX(0x656D78)
#define HdarkgrayD    RGB_HEX(0x434A54)
#define Hmorange      RGB(243,152,0)
#define HmorangeD     RGB(170,105,0)

/** 字体大小 **/
#define HFont(x) [UIFont systemFontOfSize:x]

/** 弱引用自己 */
#define SBWS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
// UI 界面大小
#define APPCONFIG_UI_SCREEN_FHEIGHT             ([UIScreen mainScreen].bounds.size.height)              //界面的高度 iphone5 568 其他480
#define APPCONFIG_UI_SCREEN_FWIDTH              ([UIScreen mainScreen].bounds.size.width)               //界面的宽度 iphone 320
#define APPCONFIG_UI_CONTROLLER_FHEIGHT         (self.view.frame.size.height)                           //界面的高度 iphone5 548 其他460
#define APPCONFIG_UI_CONTROLLER_FWIDTH          APPCONFIG_UI_SCREEN_FWIDTH                              //界面的宽度 iphone 320
#define APPCONFIG_UI_VIEW_FHEIGHT               (self.frame.size.height)                                //界面的高度 iphone5 548 其他460
#define APPCONFIG_UI_VIEW_FWIDTH                APPCONFIG_UI_SCREEN_FWIDTH                              //界面的宽度 iphone 320
#define APPCONFIG_UI_SCREEN_SIZE                ([UIScreen mainScreen].bounds.size)         //屏幕大小

#define APPCONFIG_VERSION_OVER_5                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0f)
#define APPCONFIG_VERSION_OVER_6                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f)
#define APPCONFIG_VERSION_OVER_7                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define APPCONFIG_VERSION_OVER_8                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)
#define APPCONFIG_VERSION_OVER_9                 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)


#define APPCONFIG_UNIT_LINE_WIDTH                (1/[UIScreen mainScreen].scale)       //常用线宽

/** 单例模式：声明 */
#define HAC_SINGLETON_DEFINE(_class_name_)  \
+ (_class_name_ *)shared##_class_name_;          \

/** 单例模式：实现 */
#define HAC_SINGLETON_IMPLEMENT(_class_name) HAC_SINGLETON_BOILERPLATE(_class_name, shared##_class_name)

#define HAC_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_) \
static _object_name_ *z##_shared_obj_name_ = nil;  \
+ (_object_name_ *)_shared_obj_name_ {             \
static dispatch_once_t onceToken;              \
dispatch_once(&onceToken, ^{                   \
z##_shared_obj_name_ = [[self alloc] init];\
});                                            \
return z##_shared_obj_name_;                   \
}

#define sfuc DDLogInfo(@"%s", __func__);

#import "TWCommandCenter.h"
#import "TWUtility.h"
#import "UIView+HACUtils.h"
#endif /* TWHelp_h */
