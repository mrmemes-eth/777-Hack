#import "ViewController.h"
#import "WelcomeScene.h"

@implementation ViewController {
  SKView *_spriteView;
}

-(id)init {
  if(self = [super init]) {
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.spriteView];
  }
  return self;
}

-(SKView*)spriteView {
  if (!_spriteView) {
    _spriteView = [[SKView alloc] init];
    [_spriteView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_spriteView setShowsFPS:YES];
    [_spriteView setShowsDrawCount:YES];
    [_spriteView setShowsNodeCount:YES];
  }
  return _spriteView;
}

-(void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self.spriteView presentScene:[WelcomeScene sceneWithSize:self.view.bounds.size]];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation {
  return orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight;
}

-(void)updateViewConstraints {
  [super updateViewConstraints];
  id views = @{@"view": self.spriteView};
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                    options:0 metrics:nil
                                                                      views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                    options:0 metrics:nil
                                                                       views:views]];
}

@end
