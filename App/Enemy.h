#import "SpriteSectorNode.h"
#import "PathFinder.h"

@interface Enemy : SpriteSectorNode
-(void)setPathFinderDelegate:(id<PathFinderDelegate>)delegate;
@end
