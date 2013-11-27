#import "SpriteSectorNode.h"
#import "PathFinder.h"

@class Hacker, Enemy;

@interface Board : NSObject<PathFinderDelegate>

@property(nonatomic,strong) Hacker *hacker;

+(id)boardWithHacker:(Hacker*)hacker atSector:(Sector)sector;

-(NSMutableArray*)nodes;

-(void)addNode:(SpriteSectorNode*)node;
-(void)addHacker:(Hacker*)hacker atSector:(Sector)sector;
-(void)addDataNodeAtSector:(Sector)sector;
-(void)addWarpNodeAtSector:(Sector)sector;
-(void)addEnemy:(Enemy*)enemy atSector:(Sector)sector;

-(BOOL)sectorIsOccupied:(Sector)sector;
-(BOOL)sectorIsUnoccupied:(Sector)sector;

-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction;
-(SpriteSectorNode*)nodeAtSector:(Sector)sector;

-(void)populateNodes;

-(NSArray*)mooreNodesForNode:(SpriteSectorNode*)node;
-(BOOL)placementWouldBlockBoard:(Sector)sector;

@end
