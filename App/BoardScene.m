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

@property BOOL hackerIsEnteringWarpZone;

-(SKSpriteNode*)boardNode;
-(Hacker*)hacker;
-(Board*)board;
-(void)setBoard:(Board*)board;

-(UISwipeGestureRecognizer*)upRecognizer;
-(UISwipeGestureRecognizer*)downRecognizer;
-(UISwipeGestureRecognizer*)leftRecognizer;
-(UISwipeGestureRecognizer*)rightRecognizer;

-(void)handleMovement:(UISwipeGestureRecognizer*)recognizer;
-(void)hackerWillEnterWarpZone;
-(void)hackerDidEnterWarpZone;

@end

@implementation BoardScene

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    [self setScaleMode:SKSceneScaleModeAspectFit];
    [self addChild:self.boardNode];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hackerWillEnterWarpZone)
                                                 name:HackerWillEnterWarpZone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hackerDidEnterWarpZone)
                                                 name:HackerDidEnterWarpZone object:nil];
  }
  return self;
}

-(Board*)board {
  return _board;
}

-(NSArray*)removableChildren {
  return [self.children filter:^BOOL(id node) {
    return ![node isEqual:self.boardNode] && ![node isEqual:self.hacker];
  }];
}

-(void)setBoard:(Board *)board {
  [self removeChildrenInArray:self.removableChildren];
  _board = board;
  [_board.nodes each:^(SKSpriteNode *node) {
    if (![node inParentHierarchy:self]) [self addChild:node];
  }];
}

-(SKSpriteNode*)boardNode {
  if (!_boardNode) {
    SKTexture *texture = [SKTexture textureWithCGImage:[[UIImage imageNamed:@"BoardBG"] CGImage]];
    _boardNode = [SKSpriteNode spriteNodeWithTexture:texture size:self.size];
    [_boardNode setName:@"board"];
    [_boardNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
    [_boardNode setZPosition:0];
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
  [self setBoard:[Board boardWithHacker:self.hacker atSector:SectorZero]];
}

-(CGRect)gridRect {
  return CGRectMake(0, 0, gridLength, gridLength);
}

-(void)handleMovement:(UISwipeGestureRecognizer *)recognizer {
  Sector newSector = [self.board newSectorForNode:self.hacker inDirection:recognizer.direction];
  if (SectorEqualToSector(self.hacker.sector, newSector)) {
    CGPoint point = bumpPoint(self.hacker.position, recognizer.direction);
    [self.hacker runAction:[SKAction sequence:@[[SKAction moveTo:point duration:0.05],
                                                [SKAction moveTo:self.hacker.position duration:0.05]]]];
  } else {
    [self.hacker runAction:[SKAction moveTo:CGPointFromSector(newSector) duration:0.25] completion:^{
      if (self.hackerIsEnteringWarpZone) {
        [self setBoard:[Board boardWithHacker:self.hacker atSector:self.hacker.sector]];
        [[NSNotificationCenter defaultCenter] postNotificationName:HackerDidEnterWarpZone object:nil];
      }
    }];
  }
}

-(void)hackerWillEnterWarpZone {
  [self setHackerIsEnteringWarpZone:YES];
}

-(void)hackerDidEnterWarpZone {
  [self setHackerIsEnteringWarpZone:NO];
}


@end
