#import "DataNode.h"

@implementation DataNode {
  SKPhysicsBody *_physicsBody;
}

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor greenColor]];
    [self setSize:nodeSize()];
    [self setZPosition:1];
    [self setName:@"data_node"];
  }
  return self;
}

-(SKPhysicsBody*)physicsBody {
  if (!_physicsBody) {
    _physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:nodeSize()];
    [_physicsBody setDynamic:YES];
    [_physicsBody setCategoryBitMask:nodeCategory];
    [_physicsBody setContactTestBitMask:projectileCategory|heroCategory];
  }
  return _physicsBody;
}

@end
