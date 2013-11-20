#import <XCTest/XCTest.h>
#import "SectorFunctions.h"

@interface SectorFunctionsTest : XCTestCase

@end

@implementation SectorFunctionsTest

-(void)testSectorCoordinate0 {
  XCTAssertEqual(sectorToCoordinate(0), 64, @"");
}

-(void)testSectorCoordinate1 {
  XCTAssertEqual(sectorToCoordinate(1), 192, @"");
}

-(void)testSectorCoordinate2 {
  XCTAssertEqual(sectorToCoordinate(2), 320, @"");
}

-(void)testSectorCoordinate3 {
  XCTAssertEqual(sectorToCoordinate(3), 448, @"");
}

-(void)testSectorCoordinate4 {
  XCTAssertEqual(sectorToCoordinate(4), 576, @"");
}

-(void)testSectorCoordinate5 {
  XCTAssertEqual(sectorToCoordinate(5), 704, @"");
}

-(void)testCoordinateToSector0 {
  XCTAssertEqual(coordinateToSector(64), 0, @"");
}

-(void)testCoordinateToSector1 {
  XCTAssertEqual(coordinateToSector(192), 1, @"");
}

-(void)testCoordinateToSector2 {
  XCTAssertEqual(coordinateToSector(320), 2, @"");
}

-(void)testCoordinateToSector3 {
  XCTAssertEqual(coordinateToSector(448), 3, @"");
}

-(void)testCoordinateToSector4 {
  XCTAssertEqual(coordinateToSector(576), 4, @"");
}

-(void)testCoordinateToSector5 {
  XCTAssertEqual(coordinateToSector(704), 5, @"");
}

-(void)testCGPointFromSector {
  XCTAssertEqual(CGPointFromSector(SectorMake(0, 0)), CGPointMake(64, 64), @"");
}

-(void)testSectorFromCGPoint {
  XCTAssertEqual(SectorFromCGPoint(CGPointMake(192, 192)), SectorMake(1, 1), @"");
}

-(void)testSectorEqualToSector {
  XCTAssertTrue(SectorEqualToSector(SectorMake(0, 0), SectorMake(0, 0)), @"");
  XCTAssertFalse(SectorEqualToSector(SectorMake(0, 0), SectorMake(0, 1)), @"");
}

-(void)testSectorIsNotAdjacentToSector {
  XCTAssertFalse(SectorIsAdjacentToSector(SectorMake(0, 0), SectorMake(5, 5)), @"");
  XCTAssertFalse(SectorIsAdjacentToSector(SectorMake(0, 0), SectorMake(1, 2)), @"");
  XCTAssertFalse(SectorIsAdjacentToSector(SectorMake(0, 1), SectorMake(3, 1)), @"");
  XCTAssertFalse(SectorIsAdjacentToSector(SectorMake(3, 0), SectorMake(3, 5)), @"");
}

-(void)testSectorIsAdjacentToSector {
  XCTAssertTrue(SectorIsAdjacentToSector(SectorMake(0, 0), SectorMake(0, 1)), @"");
  XCTAssertTrue(SectorIsAdjacentToSector(SectorMake(5, 5), SectorMake(4, 5)), @"");
  XCTAssertTrue(SectorIsAdjacentToSector(SectorMake(0, 0), SectorMake(1, 1)), @"");
  XCTAssertTrue(SectorIsAdjacentToSector(SectorMake(3, 3), SectorMake(2, 2)), @"");
  XCTAssertTrue(SectorIsAdjacentToSector(SectorMake(4, 4), SectorMake(5, 5)), @"");
}

-(void)testSectorIsWithinBoard {
  XCTAssertTrue(SectorIsWithinBoard(SectorMake(1, 2)), @"");
  XCTAssertTrue(SectorIsWithinBoard(SectorMake(0, 0)), @"");
  XCTAssertTrue(SectorIsWithinBoard(SectorMake(5, 5)), @"");
}

-(void)testSectorIsNotWithinBoard {
  XCTAssertFalse(SectorIsWithinBoard(SectorMake(5, 6)), @"");
  XCTAssertFalse(SectorIsWithinBoard(SectorMake(6, 0)), @"");
  XCTAssertFalse(SectorIsWithinBoard(SectorMake(42, 1)), @"");
}


@end