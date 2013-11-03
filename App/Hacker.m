#import "Hacker.h"

@implementation Hacker

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor yellowColor]];
    [self setSize:nodeSize()];
    [self setName:@"hacker"];
  }
  return self;
}

@end
