@interface BoardGenerator : NSObject

+(id)boardWithPlayerAtSector:(Sector)sector;

-(NSMutableArray*)nodes;

-(void)addPlayerAtSector:(Sector)sector;
-(void)addDataNodeAtSector:(Sector)sector;

-(BOOL)sectorIsOccupied:(Sector)sector;
-(BOOL)sectorIsUnoccupied:(Sector)sector;

-(void)populateNodes;

@end
