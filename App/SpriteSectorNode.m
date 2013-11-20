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

-(NSString*)description {
  return [NSString stringWithFormat:@"<%@> name: %@ sector: { row: %d, col: %d}  position: { x: %f, y: %f } size: { w: %f, h: %f }",NSStringFromClass(self.class), self.name, self.sector.row, self.sector.col, self.position.x, self.position.y, self.size.width, self.size.height];
}

@end
