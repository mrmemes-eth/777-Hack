#import <XCTest/XCTest.h>
#import "BoardGenerator.h"
#import <SpriteKit/SpriteKit.h>
#import "DataNode.h"

@interface BoardGeneratorTest : XCTestCase

@end

@implementation BoardGeneratorTest

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

-(void)testSectorIsOccupied {
  Sector sector = SectorMake(1,1);
  BoardGenerator *board = [BoardGenerator new];
  XCTAssertFalse([board sectorIsOccupied:sector], @"");
  [board addNodeAtSector:sector];
  XCTAssertTrue([board sectorIsOccupied:sector], @"");
}

-(void)testNodesGenerated {
  BoardGenerator *board = [BoardGenerator new];
  [board populateNodes];
  XCTAssertTrue([board.dataNodes count] >= 6, @"");
  XCTAssertFalse([board.dataNodes count] > 16, @"");
}

@end
