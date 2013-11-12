#import "Hacker.h"

@interface Hacker()
-(void)healthDidChange;
-(void)updateTexture;
@end

@implementation Hacker {
  SKPhysicsBody *_physicsBody;
}

-(id)init {
  if(self = [super init]) {
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

-(void)updateTexture {
  NSArray *textures = @[[SKColor redColor], [SKColor redColor], [SKColor orangeColor], [SKColor yellowColor]];
  [self setColor:textures[self.health]];
}

-(void)setHealth:(HackerHealth)health {
  _health = health;
  [self healthDidChange];
}

-(void)loseHealth {
  if (self.health > kHackerDead) [self setHealth:self.health - 1];
}

-(void)gainHealth {
  if (self.hasPartialHealth) [self setHealth:self.health + 1];
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

-(void)healthDidChange {
  [self updateTexture];
  [[NSNotificationCenter defaultCenter] postNotificationName:HackerHealthDidChangeNotification object:self];
}

@end
