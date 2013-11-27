#import "Enemy.h"
#import "NSValue+Sector.h"
#import "PathFinder.h"
#import "PathFinderNode.h"

@interface Enemy() {
  PathFinder *_pathFinder;
}
-(void)hackerDidMove:(NSNotification*)notification;
-(PathFinder*)pathFinder;
@end

@implementation Enemy

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor redColor]];
    [self setSize:nodeSize()];
    [self setZPosition:2];
    [self setName:@"enemy"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hackerDidMove:)
                                                 name:HackerDidMove object:nil];
  }
  return self;
}

-(void)setPathFinderDelegate:(id<PathFinderDelegate>)delegate {
  [self.pathFinder setDelegate:delegate];
}

-(PathFinder*)pathFinder {
  if (!_pathFinder) {
    _pathFinder = [PathFinder pathFinderWithMovementCost:1];
  }
  return _pathFinder;
}

-(void)hackerDidMove:(NSNotification *)notification {
  Sector destination = [notification.object sectorValue];
  NSArray *path = [self.pathFinder pathStartingAtSector:self.sector endingAtSector:destination];
  PathFinderNode *node = [path firstObject];
  [self runAction:[SKAction moveTo:CGPointFromSector(node.sector) duration:0.25]];
}

@end
