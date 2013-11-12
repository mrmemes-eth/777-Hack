#import "SpriteSectorNode.h"

typedef NS_ENUM(NSUInteger, HackerHealth) {
  kHackerDead,
  kHackerLowHealth,
  kHackerMedianHealth,
  kHackerFullHealth
};

@interface Hacker : SpriteSectorNode

@property(nonatomic) HackerHealth health;

-(void)loseHealth;
-(void)gainHealth;

-(BOOL)isDead;
-(BOOL)hasFullHealth;
-(BOOL)hasPartialHealth;

@end
