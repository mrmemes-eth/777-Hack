#import "SpriteSectorNode.h"

@interface Board : NSObject

+(id)boardWithPlayerAtSector:(Sector)sector;

-(NSMutableArray*)nodes;

-(void)addPlayerAtSector:(Sector)sector;
-(void)addDataNodeAtSector:(Sector)sector;

-(BOOL)sectorIsOccupied:(Sector)sector;
-(BOOL)sectorIsUnoccupied:(Sector)sector;
-(BOOL)sectorIsInBounds:(Sector)sector;

-(Sector)newSectorForNode:(SpriteSectorNode*)node
              inDirection:(UISwipeGestureRecognizerDirection)direction;

-(void)populateNodes;

@end
