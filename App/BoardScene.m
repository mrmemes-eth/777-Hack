#import "BoardScene.h"
#import "Hacker.h"

static const CGFloat gridLength = 128.f;
static const CGFloat gridCenter = gridLength / 2.f;

@interface BoardScene() {
  SKSpriteNode *_boardNode;
  Hacker *_hacker;
  UISwipeGestureRecognizer *_upRecognizer;
  UISwipeGestureRecognizer *_downRecognizer;
  UISwipeGestureRecognizer *_leftRecognizer;
  UISwipeGestureRecognizer *_rightRecognizer;
}

-(SKSpriteNode*)boardNode;
-(Hacker*)hacker;

-(UISwipeGestureRecognizer*)upRecognizer;
-(UISwipeGestureRecognizer*)downRecognizer;
-(UISwipeGestureRecognizer*)leftRecognizer;
-(UISwipeGestureRecognizer*)rightRecognizer;

-(void)handleMovement:(UISwipeGestureRecognizer*)recognizer;

@end

@implementation BoardScene

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    [self setScaleMode:SKSceneScaleModeAspectFit];
    [self addChild:self.boardNode];
  }
  return self;
}

-(SKSpriteNode*)boardNode {
  if (!_boardNode) {
    SKTexture *texture = [SKTexture textureWithCGImage:[[UIImage imageNamed:@"BoardBG"] CGImage]];
    _boardNode = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    [_boardNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
  }
  return _boardNode;
}

-(Hacker*)hacker {
  if (!_hacker) {
    _hacker = [Hacker new];
  }
  return _hacker;
}

-(UISwipeGestureRecognizer*)rightRecognizer {
  if (!_rightRecognizer) {
    _rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMovement:)];
    [_rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
  }
  return _rightRecognizer;
}

-(UISwipeGestureRecognizer*)leftRecognizer {
  if (!_leftRecognizer) {
    _leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMovement:)];
    [_leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
  }
  return _leftRecognizer;
}

-(UISwipeGestureRecognizer*)upRecognizer {
  if (!_upRecognizer) {
    _upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMovement:)];
    [_upRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
  }
  return _upRecognizer;
}

-(UISwipeGestureRecognizer*)downRecognizer {
  if (!_downRecognizer) {
    _downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMovement:)];
    [_downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
  }
  return _downRecognizer;
}

-(void)didMoveToView:(SKView *)view {
  [view addGestureRecognizer:self.rightRecognizer];
  [view addGestureRecognizer:self.leftRecognizer];
  [view addGestureRecognizer:self.upRecognizer];
  [view addGestureRecognizer:self.downRecognizer];
  [self addChild:self.hacker];
  [self.hacker setPosition:CGPointMake(gridCenter, gridCenter)];
}

-(void)handleMovement:(UISwipeGestureRecognizer *)recognizer {
  CGPoint newPosition;
  switch (recognizer.direction) {
    case UISwipeGestureRecognizerDirectionLeft:
      newPosition = CGPointMake(self.hacker.position.x - gridLength, self.hacker.position.y);
      break;
    case UISwipeGestureRecognizerDirectionRight:
      newPosition = CGPointMake(self.hacker.position.x + gridLength, self.hacker.position.y);
      break;
    case UISwipeGestureRecognizerDirectionUp:
      newPosition = CGPointMake(self.hacker.position.x, self.hacker.position.y + gridLength);
      break;
    case UISwipeGestureRecognizerDirectionDown:
      newPosition = CGPointMake(self.hacker.position.x, self.hacker.position.y - gridLength);
      break;
    default:
      break;
  }
  [self.hacker runAction:[SKAction moveTo:newPosition duration:0.25]];
}

@end
