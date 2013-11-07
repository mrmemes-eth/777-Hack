#import "SpriteSectorNode.h"

@class Hacker;

@interface Board : NSObject

+(id)boardWithPlayerAtSector:(Sector)sector;

-(NSMutableArray*)nodes;
-(NSArray*)reversedNodes;

-(Hacker*)hacker;

-(void)addPlayerAtSector:(Sector)sector;
-(void)addDataNodeAtSector:(Sector)sector;

-(BOOL)sectorIsOccupied:(Sector)sector;
-(BOOL)sectorIsUnoccupied:(Sector)sector;
-(BOOL)sectorIsInBounds:(Sector)sector;

-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction;
-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction
          collisionCheck:(BOOL)check;
-(SpriteSectorNode*)nodeAtSector:(Sector)sector;

-(void)populateNodes;

@end
