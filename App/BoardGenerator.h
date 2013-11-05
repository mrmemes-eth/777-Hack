@interface BoardGenerator : NSObject

+(id)board;

-(NSMutableArray*)dataNodes;

-(void)addNodeAtSector:(Sector)sector;
-(BOOL)sectorIsOccupied:(Sector)sector;
-(void)populateNodes;

@end
