//
//  SCVViewController.m
//  ScrollViewTest
//
//  Created by Bobby William Therry on 8/29/14.
//  Copyright (c) 2014 ggyCode. All rights reserved.
//



#import "SCVViewController.h"

@interface SCVViewController ()

@property (nonatomic, strong) UIImageView *imageView;

-(void) centerScrollViewContents;
-(void) scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
-(void) scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@end

@implementation SCVViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//SCROLL VIEW DOUBLE TAP
#pragma mark TAP RECOGNIZER

-(void)scrollViewTwoFingerTapped:(UITapGestureRecognizer *)recognizer{
    CGFloat newZoomScale = _scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [_scrollView setZoomScale:newZoomScale animated:YES];
    
    NSLog(@"TWO FINGER TAPPED");
}

-(void)scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer{
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = _scrollView.zoomScale *1.5f;
    newZoomScale = MIN(newZoomScale,_scrollView.maximumZoomScale);
    
    CGSize scrollViewSize = _scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w/2.0f);
    CGFloat y = pointInView.y - (h/2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x,y,w,h);
    
    [_scrollView zoomToRect:rectToZoomTo animated:YES];
    NSLog(@"Double TAPPED");
}

-(void)centerScrollViewContents{
    CGSize boundsSize = _scrollView.bounds.size;
    CGRect contentsFrame = _imageView.frame;
    
    if(contentsFrame.size.width < boundsSize.width){
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }else{
        contentsFrame.origin.x = 0.0f;
    }
    
    if(contentsFrame.size.height < boundsSize.height){
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }else{
        contentsFrame.origin.y = 0.0f;
    }
    
    _imageView.frame = contentsFrame;
    NSLog(@"CENTER SCROLL VIEW ");
}

//DELEGATE FUNCTION CALL
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

// ZOOM CALL
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self centerScrollViewContents];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _scrollView.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"photo1.png"];
    _imageView = [[UIImageView alloc]initWithImage:image];
    _imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    [_scrollView addSubview:self.imageView];
    

    _scrollView.contentSize = image.size;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [_scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGRect scrollViewFrame= _scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / _scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / _scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth,scaleHeight);
    _scrollView.minimumZoomScale = minScale;
    
    _scrollView.maximumZoomScale = 1.0f;
    _scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
