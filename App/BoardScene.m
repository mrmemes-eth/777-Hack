#import "BoardScene.h"

@interface BoardScene() {
  SKSpriteNode *_boardNode;
}
-(SKSpriteNode*)boardNode;
@end

@implementation BoardScene

-(id)initWithSize:(CGSize)size {
  if (self = [super initWithSize:size]) {
    [self setScaleMode:SKSceneScaleModeAspectFit];
    [self setBackgroundColor:[SKColor redColor]];
    [self addChild:self.boardNode];
  }
  return self;
}

-(SKSpriteNode*)boardNode {
  if (!_boardNode) {
    SKTexture *texture = [SKTexture textureWithCGImage:[[UIImage imageNamed:@"BoardBG"] CGImage]];
    _boardNode = [SKSpriteNode spriteNodeWithTexture:texture size:CGSizeMake(1024, 768)];
    [_boardNode setPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
  }
  return _boardNode;
}

@end
