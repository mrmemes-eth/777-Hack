#import "PathFinderNode.h"

@interface PathFinderNode() {
  Sector _destinationSector;
}
-(id)initWithSector:(Sector)sector;
-(NSUInteger)manhattanDistanceToSector:(Sector)destinationSector;
@end

@implementation PathFinderNode

+(id)nodeWithSector:(Sector)sector {
  return [[self.class alloc] initWithSector:sector];
}

-(id)initWithSector:(Sector)sector {
  if (self = [super init]) {
    [self setSector:sector];
    [self setMovementCost:0];
    [self setManhattanDistance:0];
  }
  return self;
}

-(NSUInteger)manhattanDistanceToSector:(Sector)destinationSector {
  return abs(self.sector.row - destinationSector.row) + abs(self.sector.col - destinationSector.col);
}

-(void)setDestinationSector:(Sector)destinationSector {
  _destinationSector = destinationSector;
  [self setManhattanDistance:[self manhattanDistanceToSector:destinationSector]];
}

-(NSUInteger)cost {
  return self.movementCost + self.manhattanDistance;
}

-(NSComparisonResult)compare:(PathFinderNode *)otherNode {
  if (self.cost < otherNode.cost) {
    return NSOrderedDescending;
  } else if (self.cost > otherNode.cost) {
    return NSOrderedAscending;
  } else {
    return NSOrderedSame;
  }
}

@end
