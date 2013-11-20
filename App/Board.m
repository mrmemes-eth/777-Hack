#import "Board.h"
#import "DataNode.h"
#import "Hacker.h"
#import "WarpNode.h"
#import "NSValue+Sector.h"

static const NSUInteger minNodes = 6;
static const NSUInteger maxNodes = 12;

static inline NSUInteger randomBetween(NSUInteger min, NSUInteger max) {
  return min + arc4random() % (max - min);
}

static inline NSMutableArray* shuffleArray(NSArray *array) {
  NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
   for (NSInteger i = mutableArray.count-1; i > 0; i--) {
    [mutableArray exchangeObjectAtIndex:i
                      withObjectAtIndex:arc4random_uniform((uint32_t)i+1)];
   }
  return mutableArray;
}

@interface Board() {
  NSMutableArray *_nodes;
  NSMutableArray *_availableSectors;
}
-(NSUInteger)nodeCount;
-(Sector)randomUnoccupiedSector;
-(Sector)randomUnoccupiedCornerSector;
-(NSArray*)shuffledCorners;
-(NSArray*)randomUnoccupiedCornerPair;
-(NSMutableArray*)availableSectors;
@end

@implementation Board

+(id)boardWithHacker:(Hacker *)hacker atSector:(Sector)sector {
  id board = [[[self class] alloc] init];
  [board addHacker:hacker atSector:sector];
  [board populateNodes];
  return board;
}

-(NSUInteger)nodeCount {
  return randomBetween(minNodes, maxNodes);
}

-(NSMutableArray*)nodes {
  if (!_nodes) {
    _nodes = [NSMutableArray array];
  }
  return _nodes;
}

-(NSArray*)shuffledCorners {
  return shuffleArray(@[@[@(0),@(0)],@[@(0),@(5)],@[@(5),@(5)],@[@(5),@(0)]]);
}

-(NSArray*)randomUnoccupiedCornerPair {
   return [self.shuffledCorners detect:^BOOL(NSArray *pair) {
     return [self sectorIsUnoccupied:SectorMakeFromArray(pair)];
   }];
}

-(Sector)randomUnoccupiedCornerSector {
  return SectorMakeFromArray(self.randomUnoccupiedCornerPair);
}

-(Sector)randomUnoccupiedSector {
  Sector sector;
  do {
    if ([self.availableSectors count] == 0) {
      NSLog(@"breaking after depleting sectors");
      break;
    }
    sector = [[self.availableSectors lastObject] sectorValue];
    [self.availableSectors removeLastObject];
  } while ([self placementWouldBlockBoard:sector]);
  return sector;
}

-(NSMutableArray*)availableSectors {
  if (!_availableSectors) {
    _availableSectors = [NSMutableArray array];
    for (NSInteger r = 0; r < gridSectors; r++) {
      for (NSInteger c = 0; c < gridSectors; c++) {
        [_availableSectors addObject:[NSValue valueWithSector:SectorMake(r, c)]];
      }
    }
    _availableSectors = shuffleArray(_availableSectors);
  }
  return _availableSectors;
}

-(void)addNode:(SpriteSectorNode *)node {
  NSValue *sectorValue = [NSValue valueWithSector:node.sector];
  [self.availableSectors removeObject:sectorValue];
  [self.nodes addObject:node];
}

-(void)addHacker:(Hacker *)hacker atSector:(Sector)sector {
  [self setHacker:hacker];
  [self.hacker setSector:sector];
  [self addNode:self.hacker];
}

-(void)addWarpNodeAtSector:(Sector)sector {
  [self addNode:[WarpNode nodeWithSector:sector]];
}

-(BOOL)sectorIsOccupied:(Sector)sector {
  return [self.nodes any:^BOOL(SpriteSectorNode *node) {
    return SectorEqualToSector(sector, node.sector);
  }];
}

-(BOOL)sectorIsUnoccupied:(Sector)sector {
  return ![self sectorIsOccupied:sector];
}

-(void)addDataNodeAtSector:(Sector)sector {
  [self addNode:[DataNode nodeWithSector:sector]];
}

-(void)populateNodes {
  [self addWarpNodeAtSector:self.randomUnoccupiedCornerSector];
  for (NSUInteger i = 0; i < self.nodeCount; i++) {
    [self addDataNodeAtSector:[self randomUnoccupiedSector]];
  }
}

-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction {
  Sector sector = SectorInDirection(node.sector, direction);
  if ([[self nodeAtSector:sector] isKindOfClass:[WarpNode class]]) {
    if ([node isKindOfClass:[Hacker class]])
      [[NSNotificationCenter defaultCenter] postNotificationName:HackerWillEnterWarpZone object:nil];
    return sector;
  } else if (SectorIsWithinBoard(sector) && [self sectorIsUnoccupied:sector]) {
    return sector;
  } else {
    return node.sector;
  }
}

-(SpriteSectorNode*)nodeAtSector:(Sector)sector {
  return [self.nodes detect:^BOOL(SpriteSectorNode *node) {
    return SectorEqualToSector(sector, node.sector);
  }];
}

-(NSArray*)nodesAdjacentToNode:(SpriteSectorNode*)node {
  return [self.nodes filter:^BOOL(SpriteSectorNode *otherNode) {
    return SectorIsAdjacentToSector(otherNode.sector, node.sector);
  }];
}

-(NSArray*)contiguousNodesForNode:(SpriteSectorNode*)node inArray:(NSMutableArray*)array {
  [[self nodesAdjacentToNode:node] each:^(SpriteSectorNode *newNode) {
    if(![array containsObject:newNode]) {
      [array addObject:newNode];
      [self contiguousNodesForNode:newNode inArray:array];
    }
  }];
  return array;
}

-(BOOL)placementWouldBlockBoard:(Sector)sector {
  SpriteSectorNode *nodeForSector = [SpriteSectorNode nodeWithSector:sector];
  NSMutableArray *nodes = [NSMutableArray arrayWithObject:nodeForSector];

  NSArray *contiguousNodes = [self contiguousNodesForNode:nodeForSector inArray:nodes];
  NSArray *borderNodes = [contiguousNodes filter:^BOOL(SpriteSectorNode *node) {
    return node.sector.row == 0 || node.sector.col  == 0 ||
           node.sector.row == gridSectors - 1 || node.sector.col == gridSectors - 1;
  }];
  return [borderNodes count] > 1;
}

@end
