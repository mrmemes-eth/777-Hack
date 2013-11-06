#import "BoardGenerator.h"
#import "DataNode.h"
#import "Hacker.h"
#import "WarpNode.h"

static const NSUInteger minNodes = 4;
static const NSUInteger maxNodes = 10;

static inline NSArray* shuffleArray(NSArray *array) {
  NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
   for (NSInteger i = mutableArray.count-1; i > 0; i--) {
    [mutableArray exchangeObjectAtIndex:i
                      withObjectAtIndex:arc4random_uniform(i+1)];
   }
  return mutableArray;
}

@interface BoardGenerator() {
  NSMutableArray *_nodes;
}
-(NSUInteger)nodeCount;
-(Sector)randomUnoccupiedSector;
-(Sector)randomUnoccupiedCornerSector;
-(NSArray*)shuffledCorners;
-(NSArray*)randomUnoccupiedCornerPair;
-(void)addWarp;
@end

@implementation BoardGenerator

+(id)boardWithPlayerAtSector:(Sector)sector {
  id board = [[[self class] alloc] init];
  [board addPlayerAtSector:sector];
  [board addWarp];
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

-(void)addPlayerAtSector:(Sector)sector {
  [self.nodes addObject:[Hacker nodeWithSector:sector]];
}

-(void)addWarp {
  [self.nodes addObject:[WarpNode nodeWithSector:self.randomUnoccupiedCornerSector]];
}

-(BOOL)sectorIsOccupied:(Sector)sector {
  return [self.nodes any:^BOOL(SpriteSectorNode *node) {
    return SectorEqualToSector(sector, node.sector);
  }];
}

-(BOOL)sectorIsUnoccupied:(Sector)sector {
  return ![self sectorIsOccupied:sector];
}

-(BOOL)sectorIsInBounds:(Sector)sector {
  return sector.col <= 5 && sector.row <= 5;
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
    sector = SectorMake(randomBetween(0, gridSectors),
                        randomBetween(0, gridSectors));
  } while ([self sectorIsOccupied:sector]);
  return sector;
}

-(void)addDataNodeAtSector:(Sector)sector {
  [self.nodes addObject:[DataNode nodeWithSector:sector]];
}

-(void)populateNodes {
  NSUInteger nodeCount = self.nodeCount;
  for (NSUInteger i = 0; i <= nodeCount; i++) {
    Sector sector = [self randomUnoccupiedSector];
    [self.nodes addObject:[DataNode nodeWithSector:sector]];
  }
}

-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction {
  Sector sector = SectorMake(node.sector.row, node.sector.col);
  switch (direction) {
    case UISwipeGestureRecognizerDirectionRight:
      sector.col += 1;
      break;
    case UISwipeGestureRecognizerDirectionLeft:
      sector.col -= 1;
      break;
    case UISwipeGestureRecognizerDirectionUp:
      sector.row += 1;
      break;
    case UISwipeGestureRecognizerDirectionDown:
      sector.row -= 1;
      break;
  }
  if ([self sectorIsUnoccupied:sector] && [self sectorIsInBounds:sector]) {
    return sector;
  } else {
    return node.sector;
  }
}

@end
