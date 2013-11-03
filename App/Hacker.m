#import "Hacker.h"

@implementation Hacker {
  SKPhysicsBody *_physicsBody;
}

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor yellowColor]];
    [self setSize:nodeSize()];
    [self setName:@"hacker"];
  }
  return self;
}

-(SKPhysicsBody*)physicsBody {
  if (!_physicsBody) {
    _physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:nodeSize()];
    [_physicsBody setDynamic:YES];
    [_physicsBody setCategoryBitMask:heroCategory];
    [_physicsBody setContactTestBitMask:projectileCategory];
  }
  return _physicsBody;
}

@end
