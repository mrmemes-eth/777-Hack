#import <XCTest/XCTest.h>
#import "Hacker.h"

@interface HackerTest : XCTestCase

@end

@implementation HackerTest

-(void)setUp {
    [super setUp];
}

-(void)tearDown {
    [super tearDown];
}

-(void)testThatHackerSpawnsWithFullHealth {
  Hacker *hacker = [Hacker new];
  XCTAssertEqual([hacker health], kHackerFullHealth, @"");
}

-(void)testThatHackerCanLoseHealth {
  Hacker *hacker = [Hacker new];
  [hacker loseHealth];
  XCTAssertEqual([hacker health], kHackerMedianHealth, @"");
}

-(void)testThatHackerCanGainHealth {
  Hacker *hacker = [Hacker new];
  [hacker setHealth:kHackerLowHealth];
  [hacker gainHealth];
  XCTAssertEqual([hacker health], kHackerMedianHealth, @"");
}

-(void)testHackerCannotHaveMoreThanFullHealth {
  Hacker *hacker = [Hacker new];
  [hacker gainHealth];
  XCTAssertEqual([hacker health], kHackerFullHealth, @"");
}

-(void)testHackerCannotBeLessThanDead {
  Hacker *hacker = [Hacker new];
  [hacker setHealth:kHackerDead];
  [hacker loseHealth];
  XCTAssertEqual([hacker health], kHackerDead, @"");
}

-(void)testHackerCannotComeBackFromDead {
  Hacker *hacker = [Hacker new];
  [hacker setHealth:kHackerDead];
  [hacker gainHealth];
  XCTAssertEqual([hacker health], kHackerDead, @"");
}

@end
