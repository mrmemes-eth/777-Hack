#import "BoardGenerator.h"
#import "DataNode.h"

static const NSUInteger minNodes = 6;
static const NSUInteger maxNodes = 16;

@interface BoardGenerator() {
  NSMutableArray *_dataNodes;
}
-(NSUInteger)nodeCount;
-(Sector)randomUnoccupiedSector;
@end

@implementation BoardGenerator

+(id)board {
  id board = [[[self class] alloc] init];
  [board populateNodes];
  return board;
}

-(NSUInteger)nodeCount {
  return randomBetween(minNodes, maxNodes);
}

-(NSMutableArray*)dataNodes {
  if (!_dataNodes) {
    _dataNodes = [NSMutableArray array];
  }
  return _dataNodes;
}

-(void)addNodeAtSector:(Sector)sector {
  DataNode *node = [DataNode nodeWithSector:sector];
  [self.dataNodes addObject:node];
}

-(BOOL)sectorIsOccupied:(Sector)sector {
  return [self.dataNodes any:^BOOL(DataNode *node) {
    return SectorEqualToSector(sector, node.sector);
  }];
}

-(Sector)randomUnoccupiedSector {
  Sector sector;
  do {
    sector = SectorMake(randomBetween(0, gridSegments),
                        randomBetween(0, gridSegments));
  } while ([self sectorIsOccupied:sector]);
  return sector;
}

-(void)populateNodes {
  NSUInteger nodeCount = self.nodeCount;
  for (NSUInteger i = 0; i <= nodeCount; i++) {
    Sector sector = [self randomUnoccupiedSector];
    DataNode *node = [DataNode nodeWithSector:sector];
    [self.dataNodes addObject:node];
  }
}

@end
