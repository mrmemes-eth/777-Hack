#import "Enemy.h"
#import "NSValue+Sector.h"

@interface Enemy()
-(void)hackerDidMove:(NSNotification*)notification;
@end

@implementation Enemy

-(id)init {
  if(self = [super init]) {
    [self setColor:[SKColor redColor]];
    [self setSize:nodeSize()];
    [self setZPosition:2];
    [self setName:@"enemy"];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hackerDidMove:)
                                                 name:HackerDidMove object:nil];
  }
  return self;
}

-(void)hackerDidMove:(NSNotification *)notification {
  log_point(self.position);
}

@end
