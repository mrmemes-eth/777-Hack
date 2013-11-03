#import "Hacker.h"

@implementation Hacker

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor yellowColor]];
    [self setSize:CGSizeMake(90, 90)];
    [self setName:@"hacker"];
  }
  return self;
}

@end
