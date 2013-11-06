#import "BoardScene.h"
#import "Hacker.h"
#import "SpriteSectorNode.h"
#import "BoardGenerator.h"

static CGPoint newPoint(CGPoint location, UISwipeGestureRecognizerDirection direction, CGFloat distance) {
  CGPoint newPoint;
  switch (direction) {
    case UISwipeGestureRecognizerDirectionLeft:
      newPoint = CGPointMake(location.x - distance, location.y);
      break;
    case UISwipeGestureRecognizerDirectionRight:
      newPoint = CGPointMake(location.x + distance, location.y);
      break;
    case UISwipeGestureRecognizerDirectionUp:
      newPoint = CGPointMake(location.x, location.y + distance);
      break;
    case UISwipeGestureRecognizerDirectionDown:
      newPoint = CGPointMake(location.x, location.y - distance);
      break;
    default:
      break;
   }
  return newPoint;
}

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

-(BOOL)sectorIsUnoccupied:(CGPoint)point;
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
  return (Hacker*)[self childNodeWithName:@"hacker"];
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
  BoardGenerator *board = [BoardGenerator boardWithPlayerAtSector:SectorZero];
  [board.nodes each:^(SpriteSectorNode *node) {
    [self addChild:node];
  }];
}

-(CGRect)gridRect {
  return CGRectMake(0, 0, gridLength, gridLength);
}

-(BOOL)sectorIsUnoccupied:(CGPoint)point {
  return ![self.children any:^BOOL(SKNode *node) {
    return CGPointEqualToPoint(point, node.position);
  }];
}

-(void)handleMovement:(UISwipeGestureRecognizer *)recognizer {
  CGPoint newPosition = newPoint(self.hacker.position, recognizer.direction, gridSegmentLength);
  if (CGRectContainsPoint(self.gridRect, newPosition) && [self sectorIsUnoccupied:newPosition]) {
    [self.hacker runAction:[SKAction moveTo:newPosition duration:0.25]];
  } else {
    CGFloat distance = (gridSegmentLength - self.hacker.size.width) / 2;
    newPosition = newPoint(self.hacker.position, recognizer.direction, distance);
    CGPoint oldPosition = self.hacker.position;
    [self.hacker runAction:[SKAction sequence:@[[SKAction moveTo:newPosition duration:0.05],
                                                [SKAction moveTo:oldPosition duration:0.05]]]];
  }
}

@end
