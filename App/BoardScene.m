#import "BoardScene.h"
#import "Hacker.h"
#import "SpriteSectorNode.h"
#import "Board.h"

static CGPoint bumpPoint(CGPoint location, UISwipeGestureRecognizerDirection direction) {
  CGFloat distance = ((gridSectorLength - nodeSize().width) / 2) - 5;
  switch (direction) {
    case UISwipeGestureRecognizerDirectionLeft:
      location.x -= distance;
      break;
    case UISwipeGestureRecognizerDirectionRight:
      location.x += distance;
      break;
    case UISwipeGestureRecognizerDirectionUp:
      location.y += distance;
      break;
    case UISwipeGestureRecognizerDirectionDown:
      location.y -= distance;
      break;
   }
  return location;
}

@interface BoardScene() {
  SKSpriteNode *_boardNode;
  Hacker *_hacker;
  UISwipeGestureRecognizer *_upRecognizer;
  UISwipeGestureRecognizer *_downRecognizer;
  UISwipeGestureRecognizer *_leftRecognizer;
  UISwipeGestureRecognizer *_rightRecognizer;
  Board *_board;
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

-(Board*)board {
  if (!_board) {
    _board = [Board boardWithPlayerAtSector:SectorZero];
  }
  return _board;
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
  [self.board.reversedNodes each:^(SpriteSectorNode *node) {
    [self addChild:node];
  }];
}

-(CGRect)gridRect {
  return CGRectMake(0, 0, gridLength, gridLength);
}

-(void)handleMovement:(UISwipeGestureRecognizer *)recognizer {
  Sector newSector = [self.board newSectorForNode:self.hacker inDirection:recognizer.direction];
  if (SectorEqualToSector(self.hacker.sector, newSector)) {
    newSector = [self.board newSectorForNode:self.hacker inDirection:recognizer.direction collisionCheck:NO];
    if ([[[self.board nodeAtSector:newSector] name] isEqualToString:@"warp"]) {
      [self.hacker runAction:[SKAction moveTo:CGPointFromSector(newSector) duration:0.25]];
    } else {
      CGPoint point = bumpPoint(self.hacker.position, recognizer.direction);
      [self.hacker runAction:[SKAction sequence:@[[SKAction moveTo:point duration:0.05],
                                                  [SKAction moveTo:self.hacker.position duration:0.05]]]];
    }
  } else {
    [self.hacker runAction:[SKAction moveTo:CGPointFromSector(newSector) duration:0.25]];
  }
}

@end
