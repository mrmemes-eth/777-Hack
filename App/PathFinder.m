#import "PathFinder.h"
#import "PathFinderNode.h"
#import "NSValue+Sector.h"

@interface PathFinder() {
  NSMutableArray *_closedNodes;
}

@property(nonatomic, strong) NSMutableArray *openNodes;

-(id)initWithMovementCost:(NSUInteger)cost;

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

-(PathFinderNode*)bestNodeFromNode:(PathFinderNode*)node toSector:(Sector)sector {
  NSArray *neighbors = [self vonNeumannNeighborsForSector:node.sector];
  [neighbors each:^(PathFinderNode *currentNode) {
    if (![self.closedNodes containsObject:currentNode]) {
      [self.openNodes addObject:currentNode];
      [currentNode setMovementCost:self.movementCost];
      [currentNode setDestinationSector:sector];
    }
  }];
  PathFinderNode *bestNode = [self.openNodes min:^NSComparisonResult(PathFinderNode *node, PathFinderNode *otherNode) {
    return [node compare:otherNode];
  }];
  [self.openNodes removeObject:bestNode];
  return bestNode;
}

-(NSArray*)pathStartingAtSector:(Sector)start endingAtSector:(Sector)end {
  [self reset];
  PathFinderNode *startNode = [PathFinderNode nodeWithSector:start];
  [self.closedNodes addObject:startNode];
  PathFinderNode *bestNode = [self bestNodeFromNode:startNode toSector:end];
  PathFinderNode *nextBestNode;
  [self.closedNodes addObject:bestNode];
  while ([self.openNodes count] > 0 && !SectorEqualToSector(bestNode.sector, end)) {
    nextBestNode = [self bestNodeFromNode:bestNode toSector:end];
    [nextBestNode setParentNode:bestNode];
    [self.closedNodes addObject:nextBestNode];
    bestNode = nextBestNode;
  }
  log_sector(bestNode.sector);
  return [NSArray arrayWithObject:bestNode];
}

@end
