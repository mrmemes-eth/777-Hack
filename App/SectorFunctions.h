static const NSUInteger gridSectors = 6;
static const CGFloat gridSectorLength = 128.f;
static const CGFloat gridSectorCenter = gridSectorLength / 2.f;
static const CGFloat gridLength = gridSectorLength * gridSectors;


static inline CGSize nodeSize() {
  return CGSizeMake(90,90);
}

typedef struct {
  NSUInteger row;
  NSUInteger col;
} Sector;

static inline NSUInteger randomBetween(NSUInteger min, NSUInteger max) {
  return min + arc4random() % (max - min);
}

static inline Sector SectorMake(NSUInteger row, NSUInteger col) {
  return (Sector) {row, col};
}

static inline Sector SectorMakeFromArray(NSArray *array) {
  return SectorMake([[array firstObject] integerValue],
                    [[array lastObject] integerValue]);
}

static inline NSUInteger sectorToCoordinate(NSUInteger sectorSegment) {
  return sectorSegment * gridSectorLength + gridSectorCenter;
}

static inline NSUInteger coordinateToSector(NSUInteger coordinate) {
  return coordinate / gridSectorLength;
}

static inline CGPoint sectorToPoint(Sector sector) {
  return CGPointMake(sectorToCoordinate(sector.col),sectorToCoordinate(sector.row));
}

static inline BOOL SectorEqualToSector(Sector sector1, Sector sector2) {
  return sector1.col == sector2.col && sector1.row == sector2.row;
}

#define SectorZero SectorMake(0,0)
#define log_sector(sec)  NSLog(@"row: %d, col: %d", sec.row, sec.col);
