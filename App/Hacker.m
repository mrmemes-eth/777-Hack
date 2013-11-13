#import "Hacker.h"

@interface Hacker()
-(void)healthDidChange;
-(void)updateTexture;
-(void)didEnterWarpZone;
@end

@implementation Hacker {
  SKPhysicsBody *_physicsBody;
}

-(id)init {
  if(self = [super init]) {
    [self setSize:nodeSize()];
    [self setName:@"hacker"];
    [self setHealth:kHackerFullHealth];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterWarpZone)
                                                 name:HackerDidEnterWarpZone object:nil];
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
  NSArray *textures = @[[SKColor grayColor], [SKColor redColor], [SKColor orangeColor], [SKColor yellowColor]];
  [self runAction:[SKAction colorizeWithColor:textures[self.health] colorBlendFactor:1.0 duration:0.15]];
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

-(void)didEnterWarpZone {
  [self gainHealth];
}

@end
