#import "DataNode.h"

@interface DataNode()
-(id)initWithSector:(Sector)sector;
@end

@implementation DataNode {
  SKPhysicsBody *_physicsBody;
}

+(id)nodeWithSector:(Sector)sector {
  CGPointEqualToPoint(CGPointZero, CGPointZero);
  return [[[self class] alloc] initWithSector:sector];
}

-(id)initWithSector:(Sector)sector {
  if (self = [self init]) {
    [self setPosition:CGPointMake(sectorToCoordinate(sector.col),
                                  sectorToCoordinate(sector.row))];
  }
  return self;
}

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor greenColor]];
    [self setSize:nodeSize()];
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

-(Sector)sector {
  return SectorMake(coordinateToSector(self.position.x),
                    coordinateToSector(self.position.y));
}

@end
