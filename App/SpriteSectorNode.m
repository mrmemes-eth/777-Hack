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
    [self setSector:sector];
  }
  return self;
}

-(Sector)sector {
  return SectorFromCGPoint(self.position);
}

-(void)setSector:(Sector)sector {
  [self setPosition:CGPointFromSector(sector)];
}

@end
