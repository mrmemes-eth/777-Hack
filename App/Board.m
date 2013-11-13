#import "Board.h"
#import "DataNode.h"
#import "Hacker.h"
#import "WarpNode.h"

static const NSUInteger minNodes = 4;
static const NSUInteger maxNodes = 10;

static inline NSArray* shuffleArray(NSArray *array) {
  NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
   for (NSInteger i = mutableArray.count-1; i > 0; i--) {
    [mutableArray exchangeObjectAtIndex:i
                      withObjectAtIndex:arc4random_uniform((uint32_t)i+1)];
   }
  return mutableArray;
}

static inline Sector sectorInDirection(Sector sector, UISwipeGestureRecognizerDirection direction) {
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
  return sector;
}

@interface Board() {
  NSMutableArray *_nodes;
}
-(NSUInteger)nodeCount;
-(Sector)randomUnoccupiedSector;
-(Sector)randomUnoccupiedCornerSector;
-(NSArray*)shuffledCorners;
-(NSArray*)randomUnoccupiedCornerPair;
-(void)addWarp;
@end

@implementation Board

+(id)boardWithHacker:(Hacker *)hacker atSector:(Sector)sector {
  id board = [[[self class] alloc] init];
  [board addHacker:hacker atSector:sector];
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

-(NSArray*)reversedNodes {
  return [[self.nodes reverseObjectEnumerator] allObjects];
}

-(void)addHacker:(Hacker *)hacker atSector:(Sector)sector {
  [self setHacker:hacker];
  [self.hacker setSector:sector];
  [self.nodes addObject:self.hacker];
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
  return [self newSectorForNode:node inDirection:direction collisionCheck:YES];
}

-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction
           collisionCheck:(BOOL)check {
  Sector sector = sectorInDirection(node.sector, direction);
  if ([[self nodeAtSector:sector] isKindOfClass:[WarpNode class]]) {
    if ([node isKindOfClass:[Hacker class]])
      [[NSNotificationCenter defaultCenter] postNotificationName:HackerWillEnterWarpZone object:nil];
    return sector;
  } else if ([self sectorIsUnoccupied:sector] && [self sectorIsInBounds:sector]) {
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

@end
