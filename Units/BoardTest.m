#import <XCTest/XCTest.h>
#import "Board.h"
#import <SpriteKit/SpriteKit.h>
#import "DataNode.h"
#import "Hacker.h"

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
  [board addHacker:[Hacker new] atSector:SectorMake(1, 1)];
  SpriteSectorNode *player =[board.nodes detect:^BOOL(SpriteSectorNode *node) {
    return [node.name isEqualToString:@"hacker"];
  }];
  Sector newSector;
  newSector = [board newSectorForNode:player inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, SectorMake(1, 2), @"");
  newSector = [board newSectorForNode:player inDirection:UISwipeGestureRecognizerDirectionLeft];
  XCTAssertEqual(newSector, SectorMake(1, 0), @"");
  newSector = [board newSectorForNode:player inDirection:UISwipeGestureRecognizerDirectionUp];
  XCTAssertEqual(newSector, SectorMake(2, 1), @"");
   newSector = [board newSectorForNode:player inDirection:UISwipeGestureRecognizerDirectionDown];
  XCTAssertEqual(newSector, SectorMake(0, 1), @"");
}

-(void)testMoveToOccupied {
  Board *board = [Board new];
  [board addHacker:[Hacker new] atSector:SectorMake(1, 1)];
  SpriteSectorNode *player =[board.nodes detect:^BOOL(SpriteSectorNode *node) {
    return [node.name isEqualToString:@"hacker"];
  }];
  [board addDataNodeAtSector:SectorMake(1, 2)];
  Sector newSector = [board newSectorForNode:player
                                 inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, player.sector, @"");
}

-(void)testMoveOutOfBounds {
  Board *board = [Board new];
  [board addHacker:[Hacker new] atSector:SectorMake(1, 5)];
  SpriteSectorNode *player =[board.nodes detect:^BOOL(SpriteSectorNode *node) {
    return [node.name isEqualToString:@"hacker"];
  }];
  Sector newSector = [board newSectorForNode:player
                                 inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, player.sector, @"");
  
  board = [Board new];
  [board addHacker:[Hacker new] atSector:SectorMake(0, 0)];
  player =[board.nodes detect:^BOOL(SpriteSectorNode *node) {
    return [node.name isEqualToString:@"hacker"];
  }];
  newSector = [board newSectorForNode:player
                                 inDirection:UISwipeGestureRecognizerDirectionLeft];
  XCTAssertEqual(newSector, player.sector, @"");
}

@end
