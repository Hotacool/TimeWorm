//
//  SetAbout.m
//  TimeWorm
//
//  Created by macbook on 16/12/16.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "SetAbout.h"

@interface SetAbout ()

@end

@implementation SetAbout

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *str = NSLocalizedString(@"About detail", @"");
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:20.0f]
                    range:NSMakeRange(0, 9)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:HdarkgrayD
                    range:NSMakeRange(0, 9)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:Hdarkgray
                    range:NSMakeRange(10, str.length-10)];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:10.0f]
                    range:NSMakeRange(10, str.length-10-16)];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:14.0f]
                    range:NSMakeRange(str.length-16, 16)];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    //行间距
    paragraph.lineSpacing = 10;
    //段落间距
    paragraph.paragraphSpacing = 10;
    //对齐方式
    paragraph.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName
                    value:paragraph
                    range:NSMakeRange(0, [str length])];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(self.view.width-10, self.view.height)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.view.width-10, rect.size.height)];
    [self.view addSubview:label];
    label.numberOfLines = 0;
    label.attributedText = attrStr;
    //mail
    str = @"mail: shisosen@163.com";
    NSMutableAttributedString *maiAttrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [maiAttrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:12.f]
                    range:NSMakeRange(0, str.length)];
    [maiAttrStr addAttribute:NSForegroundColorAttributeName
                    value:HdarkgrayD
                    range:NSMakeRange(0, str.length)];
    [maiAttrStr addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                    range:NSMakeRange(0, str.length)];
    UILabel *mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(label.frame), label.width, 20)];
    mailLabel.userInteractionEnabled = YES;
    [self.view addSubview:mailLabel];
    mailLabel.numberOfLines = 1;
    mailLabel.textAlignment = NSTextAlignmentCenter;
    mailLabel.attributedText = maiAttrStr;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mailTap:)];
    [mailLabel addGestureRecognizer:tap];

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mailTap:(id)sender {
    NSURL *url = [NSURL URLWithString:@"mailto://shisosen@163.com"];
    [[UIApplication sharedApplication] openURL:url];
}
@end
