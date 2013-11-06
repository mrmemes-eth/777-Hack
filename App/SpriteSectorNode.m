#import "SpriteSectorNode.h"

@interface SpriteSectorNode()
-(id)initWithSector:(Sector)sector;
@end

@implementation SpriteSectorNode

+(id)nodeWithSector:(Sector)sector {
  return [[[self class] alloc] initWithSector:sector];
}

-(id)initWithSector:(Sector)sector {
  if (self = [self init]) {
    [self setPosition:CGPointMake(sectorToCoordinate(sector.col),
                                  sectorToCoordinate(sector.row))];
  }
  return self;
}

-(Sector)sector {
  return SectorMake(coordinateToSector(self.position.y),
                    coordinateToSector(self.position.x));
}

@end
