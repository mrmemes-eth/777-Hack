#import "PathFinder.h"
#import "PathFinderNode.h"
#import "NSValue+Sector.h"

@interface PathFinder() {
  NSMutableArray *_openNodes;
  NSMutableArray *_closedNodes;
}
-(id)initWithMovementCost:(NSUInteger)cost;

-(NSMutableArray*)openNodes;
-(NSMutableArray*)closedNodes;
-(void)reset;

-(NSArray*)vonNeumannNeighborsForSector:(Sector)sector;
@end

@implementation PathFinder

+(id)pathFinderWithMovementCost:(NSUInteger)cost {
  return [[self.class alloc] initWithMovementCost:cost];
}

-(id)initWithMovementCost:(NSUInteger)cost {
  if (self = [super init]) {
    [self setMovementCost:cost];
  }
  return self;
}

-(NSMutableArray*)openNodes {
  if(!_openNodes) {
    _openNodes = [NSMutableArray array];
  }
  return _openNodes;
}

-(NSMutableArray*)closedNodes {
  if(!_closedNodes) {
    _closedNodes = [NSMutableArray array];
  }
  return _closedNodes;
}

-(void)reset {
  _openNodes = nil;
  _closedNodes = nil;
}

-(NSArray*)vonNeumannNeighborsForSector:(Sector)sector {
  PathFinderNode *north = [PathFinderNode nodeWithSector:SectorMake(sector.row - 1, sector.col)];
  PathFinderNode *east  = [PathFinderNode nodeWithSector:SectorMake(sector.row, sector.col + 1)];
  PathFinderNode *south = [PathFinderNode nodeWithSector:SectorMake(sector.row + 1, sector.col)];
  PathFinderNode *west  = [PathFinderNode nodeWithSector:SectorMake(sector.row, sector.col - 1)];
  return [@[north, east, south, west] filter:^BOOL(PathFinderNode *node) {
    NSLog(@"%d", [self.delegate sectorIsTraversible:node.sector]);
    return [self.delegate sectorIsTraversible:node.sector];
  }];
}

-(NSArray*)pathStartingAtSector:(Sector)start endingAtSector:(Sector)end {
  [self reset];
  NSArray *neighbors = [self vonNeumannNeighborsForSector:start];
  log_object(neighbors);
  [self.openNodes addObjectsFromArray:neighbors];
  [self.openNodes each:^(PathFinderNode *node) {
    [node setMovementCost:self.movementCost];
    [node setDestinationSector:end];
  }];
  log_object(self.openNodes);
  PathFinderNode *bestNode = [self.openNodes min:^NSComparisonResult(PathFinderNode *node, PathFinderNode *otherNode) {
    return [node compare:otherNode];
  }];
  log_sector(bestNode.sector);
  return [NSArray arrayWithObject:bestNode];
}

@end
