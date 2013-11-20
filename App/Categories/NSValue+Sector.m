#import "NSValue+Sector.h"

@implementation NSValue (Sector)
+(id)valueWithSector:(Sector)sector {
  return [NSValue value:&sector withObjCType:@encode(Sector)];
}
-(Sector)sectorValue {
  Sector sector; [self getValue:&sector]; return sector;
}
@end