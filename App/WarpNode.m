#import "WarpNode.h"

@implementation WarpNode

-(id)init {
  if (self = [super init]) {
    [self setColor:[SKColor orangeColor]];
    [self setSize:nodeSize()];
    [self setName:@"warp"];
    [self setZPosition:1];
  }
  return self;
}
@end
