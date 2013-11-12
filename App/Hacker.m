#import "Hacker.h"

@implementation Hacker {
  SKPhysicsBody *_physicsBody;
}

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor yellowColor]];
    [self setSize:nodeSize()];
    [self setName:@"hacker"];
    [self setHealth:kHackerFullHealth];
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

-(void)loseHealth {
  if (self.health > kHackerDead) self.health --;
}

-(void)gainHealth {
  if (self.hasPartialHealth) self.health ++;
}

-(BOOL)isDead {
  return self.health == kHackerDead;
}

-(BOOL)hasFullHealth {
  return self.health == kHackerFullHealth;
}

-(BOOL)hasPartialHealth {
  return !self.hasFullHealth && !self.isDead;
}

@end
