//
//  ProcessViewController.m
//  PictureProcessing
//
//  Created by 翟留闯 on 2017/3/10.
//  Copyright © 2017年 翟留闯. All rights reserved.
//

#import "ProcessViewController.h"
#import "UIImage+Category.h"
#import "UIView+Category.h"
#import "InputView.h"
#define weakify(var)   __weak typeof(var) weakSelf = var
#define NOW_SCR_H [UIScreen mainScreen].bounds.size.height
#define NOW_SCR_W [UIScreen mainScreen].bounds.size.width


@interface ProcessViewController ()<UIGestureRecognizerDelegate>


@property (strong, nonatomic) UIImageView               * baseImageView;

@property (strong, nonatomic) UIView                    * currentView;
@property (assign, nonatomic) CGPoint                   prevPoint;

@property (strong, nonatomic) UIButton                  * moveButton;

@property (strong, nonatomic) InputView                 * inputView;

@property (strong,nonatomic)  UIColor                   *textColor;
@end

@implementation ProcessViewController
{
    AppDelegate *appDelegate;
    ColorView *colorview;
    NSManagedObjectContext *context;//coredata上下文
}

@synthesize sourceImage;
@synthesize imageId;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    _textColor = [UIColor blackColor];//默认字体颜色
    appDelegate = (id)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    [self initializeUserInterface];

}


- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}


- (instancetype)initWithSourceImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        sourceImage = image;
    }
    return self;
}


#pragma mark -- initialize
- (void)initializeUserInterface
{
    //设置背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0];
    _baseImageView = ({
        UIImageView * imageView = [[UIImageView alloc] initWithImage:sourceImage];
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:imageView];
        imageView;
    });
    
    CGSize newImageSize = sourceImage.size;
    newImageSize = CGSizeMake(NOW_SCR_W - 60, (NOW_SCR_W - 60) / newImageSize.width * newImageSize.height);
    
    
    [_baseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        float imageWidth  = SCREEN_WIDTH*0.8;
        float imageHeight = sourceImage.size.height/sourceImage.size.width * imageWidth;
        make.size.mas_equalTo(CGSizeMake(imageWidth, imageHeight));
        make.center.equalTo(self.view);
    }];
    
    UITapGestureRecognizer  * sourceGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sourceImageViewTapGesture:)];
    [_baseImageView addGestureRecognizer:sourceGesture];
    
    //创建顶部取消，确定按钮
    [self createTopOptionButton];
    
    [self createBottomButton];
}

#pragma mark -- button pressed

/**
 取消修改
 */
- (void)cancelButtonPressed:(UIButton *)sender
{
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 确定修改
 
 */
- (void)sureButtonPressed:(UIButton *)sender
{
    //如果currentView的subviews等于1 说明操作按钮（删除和移动）是隐藏的 大于1时说明未隐藏
    if (_currentView.subviews.count > 1) {
        [self sourceImageViewTapGesture:nil];
    }
    
    //延迟调用截图，如果不延迟，view界面未刷新，操作按钮还存在
    [self performSelector:@selector(sure) withObject:nil afterDelay:0.001];
}


- (void)sure
{
    UIImage * newImage = [_baseImageView convertViewToImage];
    
    ShareExpressionViewController *shareViewController = [[ShareExpressionViewController alloc]init];
    shareViewController.completeImage =  newImage;
    shareViewController.completeImageName = _sourceImageName;
    shareViewController.completeImageId = imageId;
    [self.navigationController pushViewController:shareViewController animated:YES];
}





/**
 旋转图片
 
 */
- (void)rotateImageViewButtonPressed:(UIButton *)sender
{
    
    [colorview removeFromSuperview];//remo colorview
    
    UIImage * newImage = [UIImage image:_baseImageView.image rotation:UIImageOrientationLeft];
    
//    CGSize newImageSize = newImage.size;
//    newImageSize = CGSizeMake(NOW_SCR_W - 60, (NOW_SCR_W - 60) / newImageSize.width * newImageSize.height);
//    [_baseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(newImageSize);
//    }];
    
//    [_baseImageView updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(newImageSize);
//    }];
    _baseImageView.image = newImage;
}


/**
 
 改变字体颜色
 
 */
- (void)changeColorButtonPressed:(UIButton *)sender{
    
    [colorview removeFromSuperview];//remo colorview
    
    UIButton *colorButton = [self.view viewWithTag:1001];
     colorview = [[ColorView alloc]initWithSubView:self.view sureBlock:^(UIColor *color) {
        [colorButton setTitleColor:color forState:UIControlStateNormal];
        _textColor = color;
    }];
}

/**
 添加文字
 
 */
- (void)addWordsButtonPressed:(UIButton *)sender
{
    [colorview removeFromSuperview];//remo colorview
    weakify(self);
    InputView * inputView = [[InputView alloc] initWithSubView:self.view sureBlock:^(NSString *text) {
        UILabel * label = [[UILabel alloc] init];
        label.textColor = _textColor;
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        label.adjustsFontSizeToFitWidth = YES;
        [weakSelf.baseImageView addSubview:label];
        
        
        // 设置文字属性 要和label的一致
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:20]};
        
        //计算文字的宽，但是不能超过最大宽度   设置adjustsFontSizeToFitWidth为yes 自动调节字体大小适应label
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
        CGFloat label_W = textSize.width + 20;
        if (label_W > NOW_SCR_W - 100) {
            label_W = NOW_SCR_W - 100;
        }
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(label_W);
            make.height.equalTo(@30);
            make.center.equalTo(weakSelf.baseImageView);
        }];
        
        
        
        [self performSelector:@selector(createTextImageViewWithView:) withObject:label afterDelay:0.3];
    }];
    
}


/**
 将label转为图片 方便放大缩小
 
 @param view 创建的label
 */
- (void)createTextImageViewWithView:(UIView *)view
{
    UIView * textView = [[UIView alloc] init];
    [_baseImageView addSubview:textView];
    _currentView = textView;
    
    
    UIImage * newImage = [view screenshot];
    [view removeFromSuperview];
    
    CGSize imageSize = newImage.size;
    
    
    textView.bounds = CGRectMake(0, 0, imageSize.width + 60, imageSize.height + 60);
    textView.center = CGPointMake(_baseImageView.frame.size.width/2, _baseImageView.frame.size.height/2);
    
    UIImageView * newImageView = [[UIImageView alloc] initWithImage:newImage];
    newImageView.userInteractionEnabled = YES;
    [textView addSubview:newImageView];
    
    
    
    
    newImageView.frame = CGRectMake(30, 30, imageSize.width, imageSize.height);
    
    UITapGestureRecognizer * baseTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baseImageViewTapGesture:)];
    [newImageView addGestureRecognizer:baseTapGesture];
    
    UIPanGestureRecognizer * basePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(baseImageViewPan:)];
    [newImageView addGestureRecognizer:basePan];
    
    [self createOptionButton];
}


/**
 打码
 
 嵌套处理，外部一个blurryView，包含了打码的view和删除移动按钮
 
 */
- (void)addBlurryButtonPressed:(UIButton *)sender
{
    NSArray *sheetItemName = @[@"拍照",@"图库"];
    ZFActionSheet *sheet = [ZFActionSheet actionSheetWithTitle:nil confirms:sheetItemName cancel:@"取消" style:ZFActionSheetStyleDefault];
    sheet.delegate = self;
    [sheet show];
    
}


/**
 点空白处收起操作按钮（删除和移动）
 
 */
#pragma  mark点空白处收起操作按钮（删除和移动）
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _currentView.layer.borderWidth = 0;
    
    
    [colorview removeFromSuperview];//remo colorview
    
    for (UIView * view in _currentView.subviews) {
        _currentView.layer.borderWidth = 0;
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
}

/**
 打码或添加文字删除
 
 */
- (void)deleteButtonPressed:(UIButton *)sender
{
    [_currentView removeFromSuperview];
}


#pragma mark -- gesture
- (void)sourceImageViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    [colorview removeFromSuperview];//remo colorview
    _currentView.layer.borderWidth = 0;
    for (UIView * view in _currentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
}

/**
 baseImageView单击手势
 
 */
- (void)baseImageViewTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if (_currentView.subviews.count > 1) {
        [self sourceImageViewTapGesture:nil];
    }
    _currentView = tapGesture.view.superview;
    [_baseImageView bringSubviewToFront:_currentView];
    
    if (_currentView.subviews.count < 2) {
        [self createOptionButton];
    }
}


/**
 baseImageView拖动手势
 
 */
- (void)baseImageViewPan:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:_baseImageView];
    
    gesture.view.superview.center = CGPointMake(gesture.view.superview.center.x + point.x, gesture.view.superview.center.y + point.y);
    
    [gesture setTranslation:CGPointMake(0, 0) inView:_baseImageView];
    
    if (_currentView.subviews.count > 1) {
        [self sourceImageViewTapGesture:nil];
    }
    
    _currentView = gesture.view.superview;
    if (_currentView.subviews.count < 2) {
        [self createOptionButton];
    }
}


#pragma mark -- <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}


/**
 拖动手势
 
 */
- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    CGFloat baseChange = 0.0;
    
    if (state == UIGestureRecognizerStateBegan) {
        self.prevPoint = [recognizer locationInView:_currentView];
        baseChange = _currentView.bounds.size.width - self.prevPoint.x;
        
    }else if (state == UIGestureRecognizerStateChanged){
        //改变大小
        float wChange = 0.0;
        wChange = self.prevPoint.x + baseChange;
        if (wChange < 100) {
            wChange = 100;
        }
        
        float hChange = wChange / _currentView.bounds.size.width * _currentView.bounds.size.height;
        
        if (hChange < 80) {
            hChange = 80;
            wChange = hChange / _currentView.bounds.size.height * _currentView.bounds.size.width;
        }
        
        _currentView.bounds= CGRectMake(0, 0, wChange, hChange);
        //subviews[0] 打码表示图imageView
        _currentView.subviews[0].frame = CGRectMake(30, 30, CGRectGetMaxX(_currentView.bounds) -60, CGRectGetMaxY(_currentView.bounds) - 60);
        _moveButton.frame = CGRectMake(CGRectGetMaxX(_currentView.bounds) - 30, CGRectGetMaxY(_currentView.bounds) - 30, 30, 30);
        
        
        
        // 默认初始角度，触发点不在与视图中心点水平的位置上时需要计算初始角度大小
        CGFloat firstAngle = atan2(- _currentView.bounds.size.height / 2 - _currentView.bounds.origin.y,_currentView.bounds.size.width / 2 - _currentView.bounds.origin.x);
        
        // 计算旋转角度
        CGFloat slope = atan2([recognizer locationInView:_currentView.superview].y - _currentView.center.y, [recognizer locationInView:_currentView.superview].x - _currentView.center.x);
        
        _currentView.transform = CGAffineTransformMakeRotation(slope + firstAngle);
        
        [recognizer setTranslation:CGPointZero inView:_currentView];
        self.prevPoint = [recognizer locationOfTouch:0 inView:_currentView];
        
    }else if ([recognizer state] == UIGestureRecognizerStateEnded){
        self.prevPoint = [recognizer locationInView:_currentView];
        
    }
}

- (void)rotationGestureDetected:(UIRotationGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        CGFloat rotation = [recognizer rotation];
        [_currentView setTransform:CGAffineTransformRotate(_currentView.transform, rotation)];
        [recognizer setRotation:0];
    }
}

#pragma mark -- create view

/**
 创建顶部确定取消按钮
 */
- (void)createTopOptionButton
{
    UIButton * cancelButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];
    
    UIButton * sureButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton addTarget:self action:@selector(sureButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:sureButton];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@30);
        make.top.mas_equalTo(@50);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@50);
        make.right.equalTo(@-30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


/**
 创建底部按钮
 */
- (void)createBottomButton
{
    NSArray * bottomTitleArray = [NSArray arrayWithObjects:@"旋转",@"颜色",@"文字",@"打码", nil];
    CGFloat margin = 20;
    CGFloat button_W = 70;
    
    CGFloat buttonMargin = (NOW_SCR_W - margin * 2 - button_W)/3.0;
    
    for (int i = 0; i < bottomTitleArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        button.layer.cornerRadius=3;
        button.layer.masksToBounds = YES;
        [button setTitle:bottomTitleArray[i] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = 1000+i;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(margin + buttonMargin * i);
            make.bottom.equalTo(@-20);
            make.size.mas_equalTo(CGSizeMake(button_W, 30));
        }];
        
        if (i == 0) {
            [button addTarget:self action:@selector(rotateImageViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else if ( i == 1){
            [button addTarget:self action:@selector(changeColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else if ( i == 2){
            [button addTarget:self action:@selector(addWordsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button addTarget:self action:@selector(addBlurryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}





/**
 创建操作按钮，删除和移动
 
 按钮只设置了背景颜色，用时可换成图标
 
 */
- (void)createOptionButton
{
    
    //删除
    UIButton * deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
//    deleteBut.backgroundColor = [UIColor redColor];
    [deleteBut setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [deleteBut addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_currentView addSubview:deleteBut];
    
    [deleteBut mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.left.equalTo(@0);
    }];
    
    
    _currentView.layer.borderWidth = 2;
    _currentView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:0.6].CGColor;
    
    //移动
    UIButton * removeBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeBut setBackgroundImage:[UIImage imageNamed:@"dakai"] forState:UIControlStateNormal];
    [_currentView addSubview:removeBut];
    _moveButton = removeBut;
    
    removeBut.frame = CGRectMake(CGRectGetMaxX(_currentView.bounds) - 30, CGRectGetMaxY(_currentView.bounds) - 30, 30, 30);
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    [panGestureRecognizer setDelegate:self];
    [removeBut addGestureRecognizer:panGestureRecognizer];
}





#pragma mark --选择图片
/**
 *  选择图片
 *
 *  @param actionSheet 选择方式的sheet
 *  @param index       当前选择的index
 */
- (void)clickAction:(ZFActionSheet *)actionSheet atIndex:(NSUInteger)index
{
    
    // 1、创建ZFImagePicker对象
    ZFImagePicker *picker = [[ZFImagePicker alloc] init];
    picker.isEdit = YES;
    
    if (index==0) {
        // 3、设置图片来源(若不设置默认来自图库)
        picker.sType = SourceTypeCamera;
    }else if(index==1){
        picker.sType = SourceTypeLibrary;
    }else if(index==2){
        picker.sType = SourceTypeAlbum;
    }
    
    
    
    
    // 实现block回调
    picker.pickImage = ^(UIImage *image,NSString *type,NSString *name){
        //此处为拿到的图片及类型
        //imgView.image = image;
        
        
        UIView * blurryView = [[UIView alloc] init];
        [_baseImageView addSubview:blurryView];
        if (_currentView) {
            [self sourceImageViewTapGesture:nil];
        }
        _currentView = blurryView;
        
        int randomNum = (int)arc4random() % 20;
        
        CGFloat imageCenterX = _baseImageView.frame.size.width / 2.0 + randomNum;
        CGFloat imageCenterY = _baseImageView.frame.size.height / 2.0 + randomNum;
        
        blurryView.bounds = CGRectMake(0, 0, 120, 120);
        blurryView.center = CGPointMake(imageCenterX, imageCenterY);
        
       // UIImageView * newImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"singledog"]];
        UIImageView * newImageView = [[UIImageView alloc] initWithImage:image];
        newImageView.userInteractionEnabled = YES;
        [blurryView addSubview:newImageView];
        
        newImageView.frame = CGRectMake(30, 30, CGRectGetMaxX(_currentView.bounds) -60, CGRectGetMaxY(_currentView.bounds) - 60);
        
        UITapGestureRecognizer * baseTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(baseImageViewTapGesture:)];
        [newImageView addGestureRecognizer:baseTapGesture];
        
        UIPanGestureRecognizer * basePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(baseImageViewPan:)];
        [newImageView addGestureRecognizer:basePan];
        
        [self createOptionButton];
        
    };
    
    // 4、弹出界面
    [self presentViewController:picker animated:YES completion:nil];
    
}



@end
