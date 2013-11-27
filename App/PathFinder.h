#import <Foundation/Foundation.h>

@protocol PathFinderDelegate <NSObject>
-(BOOL)sectorIsTraversible:(Sector)sector;
@end

@interface PathFinder : NSObject

@property(nonatomic,strong) id<PathFinderDelegate> delegate;
@property NSUInteger movementCost;

+(id)pathFinderWithMovementCost:(NSUInteger)cost;

-(NSArray*)pathStartingAtSector:(Sector)start endingAtSector:(Sector)end;
@end
