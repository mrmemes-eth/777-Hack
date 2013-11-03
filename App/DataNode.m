#import "DataNode.h"

@implementation DataNode

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor greenColor]];
    [self setSize:nodeSize()];
    [self setName:@"data_node"];
  }
  return self;
}

@end
