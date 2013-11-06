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
  [board addDataNodeAtSector:sector];
  XCTAssertTrue([board sectorIsOccupied:sector], @"");
}

-(void)testNodesGenerated {
  BoardGenerator *board = [BoardGenerator new];
  [board populateNodes];
  XCTAssertTrue([board.nodes count] >= 4, @"");
  XCTAssertFalse([board.nodes count] > 12, @"");
}

-(void)testMoveToUnoccupied {
  BoardGenerator *board = [BoardGenerator new];
  [board addPlayerAtSector:SectorMake(1, 1)];
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
  BoardGenerator *board = [BoardGenerator new];
  [board addPlayerAtSector:SectorMake(1, 1)];
  SpriteSectorNode *player =[board.nodes detect:^BOOL(SpriteSectorNode *node) {
    return [node.name isEqualToString:@"hacker"];
  }];
  [board addDataNodeAtSector:SectorMake(1, 2)];
  Sector newSector = [board newSectorForNode:player
                                 inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, player.sector, @"");
}

-(void)testMoveOutOfBounds {
  BoardGenerator *board = [BoardGenerator new];
  [board addPlayerAtSector:SectorMake(1, 5)];
  SpriteSectorNode *player =[board.nodes detect:^BOOL(SpriteSectorNode *node) {
    return [node.name isEqualToString:@"hacker"];
  }];
  Sector newSector = [board newSectorForNode:player
                                 inDirection:UISwipeGestureRecognizerDirectionRight];
  XCTAssertEqual(newSector, player.sector, @"");
  
  board = [BoardGenerator new];
  [board addPlayerAtSector:SectorMake(0, 0)];
  player =[board.nodes detect:^BOOL(SpriteSectorNode *node) {
    return [node.name isEqualToString:@"hacker"];
  }];
  newSector = [board newSectorForNode:player
                                 inDirection:UISwipeGestureRecognizerDirectionLeft];
  XCTAssertEqual(newSector, player.sector, @"");
}

@end
