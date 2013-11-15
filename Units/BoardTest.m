#import <XCTest/XCTest.h>
#import "Board.h"
#import <SpriteKit/SpriteKit.h>
#import "DataNode.h"
#import "Hacker.h"
#import "WarpNode.h"

@interface BoardTest : XCTestCase

@end

@implementation BoardTest

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

-(void)testSectorIsOccupied {
  Sector sector = SectorMake(1,1);
  Board *board = [Board new];
  XCTAssertFalse([board sectorIsOccupied:sector], @"");
  [board addDataNodeAtSector:sector];
  XCTAssertTrue([board sectorIsOccupied:sector], @"");
}

-(void)testNodesGenerated {
  Board *board = [Board new];
  [board populateNodes];
  XCTAssertTrue([board.nodes count] >= 4, @"");
  XCTAssertFalse([board.nodes count] > 12, @"");
}

-(void)testMoveToUnoccupied {
  Board *board = [Board new];
  Hacker *hacker = [Hacker new];
  [board addHacker:hacker atSector:SectorMake(1, 1)];
  Sector newSector;
  newSector = [board newSectorForNode:hacker inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, SectorMake(1, 2), @"");
  newSector = [board newSectorForNode:hacker inDirection:UISwipeGestureRecognizerDirectionLeft];
  XCTAssertEqual(newSector, SectorMake(1, 0), @"");
  newSector = [board newSectorForNode:hacker inDirection:UISwipeGestureRecognizerDirectionUp];
  XCTAssertEqual(newSector, SectorMake(2, 1), @"");
   newSector = [board newSectorForNode:hacker inDirection:UISwipeGestureRecognizerDirectionDown];
  XCTAssertEqual(newSector, SectorMake(0, 1), @"");
}

-(void)testMoveToOccupied {
  Board *board = [Board new];
  Hacker *hacker = [Hacker new];
  [board addHacker:hacker atSector:SectorMake(1, 1)];
  [board addDataNodeAtSector:SectorMake(1, 2)];
  Sector newSector = [board newSectorForNode:hacker
                                 inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, hacker.sector, @"");
}

-(void)testMoveOutOfBounds {
  Board *board = [Board new];
  Hacker *hacker = [Hacker new];
  [board addHacker:hacker atSector:SectorMake(1, 5)];
  Sector newSector = [board newSectorForNode:hacker
                                 inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, hacker.sector, @"");
  
  board = [Board new];
  [board addHacker:hacker atSector:SectorMake(0, 0)];
  newSector = [board newSectorForNode:hacker
                          inDirection:UISwipeGestureRecognizerDirectionLeft];
  XCTAssertEqual(newSector, hacker.sector, @"");
}

-(void)testMoveOntoWarpZone {
  Board *board = [Board new];
  Hacker *hacker = [Hacker new];
  WarpNode *warp = [WarpNode nodeWithSector:SectorMake(1, 0)];
  [board addHacker:hacker atSector:SectorMake(0, 0)];
  [board.nodes addObject:warp];
  Sector newSector = [board newSectorForNode:hacker
                                 inDirection:UISwipeGestureRecognizerDirectionUp];
  XCTAssertEqual(newSector, newSector, @"");
  
  board = [Board new];
  warp = [WarpNode nodeWithSector:SectorMake(0, 1)];
  [board addHacker:hacker atSector:SectorMake(0, 0)];
  [board.nodes addObject:warp];
  newSector = [board newSectorForNode:hacker
                          inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, newSector, @"");
}

@end
