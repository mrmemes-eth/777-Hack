#import "SpriteSectorNode.h"

@class Hacker;

@interface Board : NSObject

@property(nonatomic,strong) Hacker *hacker;

+(id)boardWithHacker:(Hacker*)hacker atSector:(Sector)sector;

-(NSMutableArray*)nodes;
-(NSArray*)reversedNodes;

-(void)addHacker:(Hacker*)hacker atSector:(Sector)sector;
-(void)addDataNodeAtSector:(Sector)sector;

-(BOOL)sectorIsOccupied:(Sector)sector;
-(BOOL)sectorIsUnoccupied:(Sector)sector;
-(BOOL)sectorIsInBounds:(Sector)sector;

-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction;
-(SpriteSectorNode*)nodeAtSector:(Sector)sector;

-(void)populateNodes;

@end
