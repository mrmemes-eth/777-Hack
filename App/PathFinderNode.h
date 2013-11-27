#import <Foundation/Foundation.h>

@interface PathFinderNode : NSObject

@property Sector sector;

@property(nonatomic, strong) PathFinderNode *parentNode;
@property NSUInteger movementCost;
@property NSUInteger manhattanDistance;

+(id)nodeWithSector:(Sector)sector;

-(void)setDestinationSector:(Sector)destinationSector;
-(NSUInteger)cost;
-(NSComparisonResult)compare:(PathFinderNode*)otherNode;

@end
