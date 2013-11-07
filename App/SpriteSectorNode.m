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
    [self setPosition:CGPointFromSector(sector)];
  }
  return self;
}

-(Sector)sector {
  return SectorFromCGPoint(self.position);
}

@end
